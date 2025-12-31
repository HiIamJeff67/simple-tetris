import SwiftUI

func getTimeString(from interval: TimeInterval) -> String {
    let totalSeconds = Int(interval)
    let minutes = totalSeconds / 60
    let seconds = totalSeconds % 60
    return String(format: "%02d:%02d", minutes, seconds)
}
