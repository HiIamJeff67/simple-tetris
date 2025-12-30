import Combine
import Observation

@Observable
class SettingsViewModel: ObservableObject {
    var settings: SettingsModel
    
    init() {
        self.settings = SettingsModel(
            width: 6,
            height: 12,
            fallingSpeedMultiplier: 2,
            backgroundStyle: .classic
        )
    }
    
    func updateWidth(_ width: Int) {
        if (width < MinWidth || width > MaxWidth) {
            return
        }
        self.settings.width = width
    }
    
    func updateHeight(_ height: Int) {
        if (height < MinHeight || height > MaxHeight) {
            return
        }
        self.settings.height = height
    }
    
    func updateFallingSpeedMultiplier(_ fallingSpeedMultiplier: Double) {
        if (fallingSpeedMultiplier < MinFallingSpeedMultiplier || fallingSpeedMultiplier > MaxFallingSpeedMultiplier) {
            return
        }
        self.settings.fallingSpeedMultiplier = fallingSpeedMultiplier
    }
}
