enum BackgroundStyle: String, CaseIterable, Identifiable {
    case classic
    case dark
    case neon

    var id: String { rawValue }

    var imageName: String {
        switch self {
        case .classic: return "bg_classic"
        case .dark: return "bg_dark"
        case .neon: return "bg_neon"
        }
    }
}
