import Foundation
import SwiftData

@Model
final class ScoreModel: Identifiable {
    @Attribute(.unique) var id: UUID
    var score: Int
    var date: Date
    var duration: TimeInterval

    init(score: Int, date: Date = Date(), duration: TimeInterval) {
        self.id = UUID()
        self.score = score
        self.date = date
        self.duration = duration
    }
}
