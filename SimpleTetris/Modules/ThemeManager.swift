import SwiftUI
import Combine

enum ThemePreference: String, CaseIterable, Identifiable {
    case system, light, dark
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

@MainActor
final class ThemeManager: ObservableObject {
    @AppStorage("themePreference") private var stored = ThemePreference.system.rawValue
    @Published var preference: ThemePreference {
        didSet { stored = preference.rawValue }
    }

    init() {
        let raw = UserDefaults.standard.string(forKey: "themePreference")
        self.preference = ThemePreference(rawValue: raw ?? ThemePreference.system.rawValue) ?? .system
    }
    
    var isDark: Bool {
        return preference == .dark
    }
    
    func toggle() -> Void {
        self.preference = (self.preference == .dark) ? .light : .dark
    }
}
