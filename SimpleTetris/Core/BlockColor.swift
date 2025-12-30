import SwiftUI

enum BlockColor: String, CaseIterable, Identifiable {
    case blue
    case red
    case green
    case purple
    case yellow
    case orange
    case cyan
    
    var id: String { rawValue }
    
    func getUIColor() -> Color {
        switch self {
        case .blue: return .blue
        case .red: return .red
        case .green: return .green
        case .purple: return .purple
        case .yellow: return .yellow
        case .orange: return .orange
        case .cyan: return .cyan
        }
    }
}
