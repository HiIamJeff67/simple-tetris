import SwiftUI
import SwiftData
import Combine
import Observation
import Foundation

@MainActor
class GameViewModel: ObservableObject {
    @Published var gameContent: GameContent // fake game board to display on the user interface
    @Published var isGameOver: Bool
    @Published var currentScore: Int = 0
    @Published var elapsedTime: TimeInterval = 0
    private var gameEngine: GameEngine! // actual game board
    private var gameTask: Task<Void, Never>?
    private let tickInterval: TimeInterval = 1.0
    var modelContext: ModelContext?
    
    func tick() async {
        guard let ge = self.gameEngine else { return }
        _ = await ge.moveDown()
        let newContent = await ge.getContent()
        await MainActor.run {
            self.gameContent = newContent
        }
        self.currentScore = await ge.currentScore
        self.elapsedTime += self.tickInterval
        self.isGameOver = await ge.isGameOver
//        print("isGameOver: ", self.isGameOver)
    }

    init() {
        self.gameContent = GameContent()
        self.isGameOver = true // initial to be true, once the user click the start button to set this to false
        self.gameEngine = nil
        Task { @MainActor in
            let settings = SettingsModel(
                width: 6,
                height: 16,
                fallingSpeedMultiplier: 1.5,
                backgroundStyle: .classic
            )
            let initialGameEngine = await GameEngine(
                maxPieceQueueSize: 5,
                scorePerBlock: 10,
                settings: settings,
                isInitialGameOver: true,
            )
            self.gameEngine = initialGameEngine
            await initialGameEngine.start()
            let newContent = await initialGameEngine.getContent()
            self.gameContent = newContent
        }
    }
    
    func initialize(settings: SettingsModel, modelContext: ModelContext) async {
        self.gameEngine = await GameEngine(
            maxPieceQueueSize: 5,
            scorePerBlock: 10,
            settings: settings,
            isInitialGameOver: false,
        )
        await self.gameEngine.start()
        self.gameContent = await self.gameEngine!.getContent()
        self.modelContext = modelContext
        self.currentScore = 0
        self.elapsedTime = 0
    }
    
    func startGameLoop() {
        gameTask?.cancel()
        gameTask = Task { [weak self] in
            guard let self = self else { return }
            while !Task.isCancelled {
                await tick()
                if self.isGameOver {
                    self.stopGameLoop()
                    return
                }
                
                try? await Task.sleep(nanoseconds: UInt64(self.tickInterval * 1_000_000_000))
            }
        }
    }
    
    func stopGameLoop() {
        self.gameTask?.cancel()
        self.gameTask = nil
    }
    
    func saveScore() {
        guard isGameOver, let ge = self.gameEngine, let context = self.modelContext else { return }
        Task { @MainActor in
            let score = await ge.currentScore
            let scoreModel = ScoreModel(score: score, duration: elapsedTime)
            context.insert(scoreModel)
            do {
                try context.save()
                print("Score saved: \(scoreModel.score), duration: \(scoreModel.duration)")
                let descriptor = FetchDescriptor<ScoreModel>()
                let allScores = try context.fetch(descriptor)
                print("All scores in modelContext:")
                for s in allScores {
                    print("score: \(s.score), duration: \(s.duration), date: \(s.date)")
                }
            } catch {
                print("Failed to save score: \(error)")
            }
        }
    }

    func moveLeft() {
        Task {
            guard let gameEngine = self.gameEngine else { return }
            _ = await gameEngine.moveLeft()
            let newContent = await gameEngine.getContent()
            await MainActor.run {
                self.gameContent = newContent
            }
        }
    }

    func moveRight() {
        Task {
            guard let ge = self.gameEngine else { return }
            _ = await ge.moveRight()
            let newContent = await ge.getContent()
            await MainActor.run {
                self.gameContent = newContent
            }
        }
    }

    func moveDown() {
        Task {
            guard let ge = self.gameEngine else { return }
            _ = await ge.moveDown()
            let newContent = await ge.getContent()
            await MainActor.run {
                self.gameContent = newContent
            }
        }
    }

    func rotateClockwise() {
        Task {
            guard let ge = self.gameEngine else { return }
            _ = await ge.rotateClockwise()
            let newContent = await ge.getContent()
            await MainActor.run {
                self.gameContent = newContent
            }
        }
    }

    func rotateCounterClockwise() {
        Task {
            guard let ge = self.gameEngine else { return }
            _ = await ge.rotateCounterClockwise()
            let newContent = await ge.getContent()
            await MainActor.run {
                self.gameContent = newContent
            }
        }
    }
}
