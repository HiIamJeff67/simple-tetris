import SwiftUI
import SwiftData

@main
struct SimpleTetrisApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ScoreModel.self])
    }
}
