import SwiftUI

struct GameView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: GameViewModel = GameViewModel()
    @State private var hasGameStarted = false
    @State private var fastDropTask: Task<Void, Never>?
    
    private func startFastDrop() {
        guard fastDropTask == nil else { return }

        fastDropTask = Task {
            while !Task.isCancelled {
                vm.moveDown()
                try? await Task.sleep(nanoseconds: 50_000_000)
            }
        }
    }

    private func stopFastDrop() {
        fastDropTask?.cancel()
        fastDropTask = nil
    }

    var body: some View {
        GeometryReader { geometry in
            let boardRows = vm.gameContent.board.count
            let boardCols = vm.gameContent.board.first?.count ?? 0
            let cellSize = min(geometry.size.width / CGFloat(boardCols), geometry.size.height / CGFloat(boardRows))
            let boardWidth = cellSize * CGFloat(boardCols)
            let boardHeight = cellSize * CGFloat(boardRows)
            
            ZStack {
                VStack (spacing: 0) {
                    ForEach(0..<boardRows, id: \.self) { y in
                        HStack(spacing: 0) {
                            ForEach(0..<boardCols, id: \.self) { x in
                                Rectangle()
                                    .fill(vm.gameContent.board[y][x]?.getUIColor() ?? .clear)
                                    .frame(width: cellSize, height: cellSize)
                                    .border(.gray, width: 1)
                            }
                        }
                    }
                } // end of VStack
                .frame(width: boardWidth, height: boardHeight)
                .zIndex(0)
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onEnded { value in
                            if abs(value.translation.width) > abs(value.translation.height) {
                                if value.translation.width > 0 {
                                    vm.moveRight()
                                } else {
                                    vm.moveLeft()
                                }
                            }
                        }
                )
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            vm.rotateClockwise()
                        }
                )
                
                Group {
                    if !hasGameStarted {
                        Button(action: {
                            hasGameStarted = true
                            vm.isGameOver = false
                            vm.startGameLoop()
                        }) {
                            Text("開始遊戲")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 20)
                                .background(Color.green)
                                .cornerRadius(20)
                                .shadow(radius: 10)
                        }
                    } else if vm.isGameOver {
                        VStack(spacing: 24) {
                            Text("Game Over")
                                .font(.largeTitle.bold())
                                .foregroundColor(.red)
                            Text("分數：\(vm.currentScore)")
                                .font(.title)
                                .foregroundColor(.orange)
                            Button(action: {
                                Task {
                                    await vm.initialize(
                                        settings: settingsViewModel.settings,
                                        modelContext: modelContext,
                                    )
                                    vm.isGameOver = false
                                    vm.startGameLoop()
                                }
                            }) {
                                Text("再玩一次")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 16)
                                    .background(Color.green)
                                    .cornerRadius(16)
                                    .shadow(radius: 8)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(24)
                        .shadow(radius: 12)
                    }
                } // end of Group
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(1)
                
                LongPressOverlay(
                    onBegan: startFastDrop,
                    onEnded: stopFastDrop
                ) // end of LongPressOverlay
            } // end of ZStack
            .overlay(
                PieceQueueView(pieces: vm.gameContent.pieceQueue)
                    .frame(width: 80, height: 160)
                    .padding(.top, 36)
                    .padding(.trailing, 12),
                alignment: .topTrailing
            )
        } // end of GeometryReader
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("返回")
                    }
                }
            }
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: "clock")
                    Text(getTimeString(from: vm.elapsedTime))
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Image(systemName: "star.fill")
                    Text("\(vm.currentScore)")
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            }
        } // end of toolbar
        .onAppear {
            vm.modelContext = modelContext
        } // end of onAppear
        .task {
            await vm.initialize(
                settings: settingsViewModel.settings,
                modelContext: modelContext
            )
        } // end of task
        .onDisappear {
            vm.stopGameLoop()
        } // end of onDisapear
        .onChange(of: vm.isGameOver) { _, newValue in
            if newValue && hasGameStarted {
                vm.saveScore()
            }
        } // end of onChange
    } // end of body
} // end of GameView
