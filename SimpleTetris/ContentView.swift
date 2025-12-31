import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some View {
        NavigationStack {
            HomeView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.preference.colorScheme)
        }
    }
}

#Preview {
    ContentView()
        .environment(SettingsViewModel())
}
