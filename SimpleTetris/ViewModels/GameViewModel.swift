import SwiftUI
import Combine
import Observation
import Foundation

@MainActor
class GameViewModel: ObservableObject {
    @Published var boardContent: BoardContent
    private var board: Board!
    private var gameTask: Task<Void, Never>?
    private var counter: Int = 0
    
    func startGameLoop() {
        gameTask?.cancel()
        gameTask = Task { [weak self] in
            guard let self = self else { return }
            // Wait until the board is ready
            while self.board == nil && !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 50_000_000)
            }
            guard let board = self.board else { return }
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                _ = await board.moveDown()
                let newContent = await board.getContent()
                await MainActor.run {
                    self.boardContent = newContent
                }
                // asd
            }
        }
    }
    
    func stopGameLoop() {
        self.gameTask?.cancel()
        self.gameTask = nil
    }

    init() {
        self.boardContent = BoardContent()
        self.board = nil
        Task { @MainActor in
            let settings = SettingsModel(
                width: 6,
                height: 12,
                fallingSpeedMultiplier: 1.5,
                backgroundStyle: .classic
            )
            let createdBoard = await Board(
                maxPieceQueueSize: 5,
                scorePerBlock: 10,
                settings: settings
            )
            self.board = createdBoard
            await createdBoard.initialize()
            let newContent = await createdBoard.getContent()
            self.boardContent = newContent
            self.startGameLoop()
        }
    }
    
    func initialize(settings: SettingsModel) async {
        self.board = await Board(maxPieceQueueSize: 5, scorePerBlock: 10, settings: settings)
        self.boardContent = await board!.getContent()
    }

    func moveLeft() {
        Task {
            guard let board = self.board else { return }
            _ = await board.moveLeft()
            let newContent = await board.getContent()
            await MainActor.run {
                self.boardContent = newContent
            }
        }
    }

    func moveRight() {
        Task {
            guard let board = self.board else { return }
            _ = await board.moveRight()
            let newContent = await board.getContent()
            await MainActor.run {
                self.boardContent = newContent
            }
        }
    }

    func moveDown() {
        Task {
            guard let board = self.board else { return }
            _ = await board.moveDown()
            let newContent = await board.getContent()
            await MainActor.run {
                self.boardContent = newContent
            }
        }
    }

    func rotateClockwise() {
        Task {
            guard let board = self.board else { return }
            _ = await board.rotateClockwise()
            let newContent = await board.getContent()
            await MainActor.run {
                self.boardContent = newContent
            }
        }
    }

    func rotateCounterClockwise() {
        Task {
            guard let board = self.board else { return }
            _ = await board.rotateCounterClockwise()
            let newContent = await board.getContent()
            await MainActor.run {
                self.boardContent = newContent
            }
        }
    }
}
