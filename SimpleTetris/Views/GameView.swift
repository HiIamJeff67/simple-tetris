import SwiftUI

struct GameView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: GameViewModel = GameViewModel()
    @State private var hasGameStarted = false
    @State private var isAccelerating = false

    var body: some View {
        GeometryReader { geometry in
            let boardRows = vm.gameContent.board.count
            let boardCols = vm.gameContent.board.first?.count ?? 0
            let cellSize = min(geometry.size.width / CGFloat(boardCols), geometry.size.height / CGFloat(boardRows))
            let boardWidth = cellSize * CGFloat(boardCols)
            let boardHeight = cellSize * CGFloat(boardRows)
            
            ZStack {
                VStack(spacing: 0) {
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
                }
                .frame(width: boardWidth, height: boardHeight)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
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
                    LongPressGesture(minimumDuration: 0.2)
                        .onEnded { _ in
                            vm.moveDown()
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
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(1)
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 16) {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("返回")
                        }
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        Text(timeString(from: vm.elapsedTime))
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                        Text("\(vm.currentScore)")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
            }
        }
        .onAppear {
            vm.modelContext = modelContext
        }
        .task {
            await vm.initialize(
                settings: settingsViewModel.settings,
                modelContext: modelContext
            )
        }
        .onDisappear {
            vm.stopGameLoop()
        }
        .onChange(of: vm.isGameOver) { _, newValue in
            if newValue && hasGameStarted {
                vm.saveScore()
            }
        }
    }

    private func timeString(from interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
