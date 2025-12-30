import SwiftUI

struct GameView: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    @StateObject private var vm = GameViewModel()

    var body: some View {
        VStack {
            ForEach(0..<vm.boardContent.grid.count, id: \.self) { y in
                HStack {
                    ForEach(0..<vm.boardContent.grid[y].count, id: \.self) { x in
                        Rectangle()
                            .fill(vm.boardContent.grid[y][x]?.getUIColor() ?? .clear)
                            .frame(width: 20, height: 20)
                            .border(.gray, width: 1)
                    }
                }
            }

            HStack {
                Button("←") { vm.moveLeft() }
                Button("↓") { vm.moveDown() }
                Button("→") { vm.moveRight() }
                Button("↻") { vm.rotateClockwise() }
            }
        }
        .task {
            // async 初始化放在 task 裡面
            await vm.initialize(settings: settingsVM.settings)
            vm.startGameLoop() // 開始遊戲循環
        }
        .onDisappear {
            vm.stopGameLoop()
        }
    }
}
