struct SettingsModel {
    var width: Int = 6
    var height: Int = 12
    var fallingSpeedMultiplier: Double = 1.5
    var backgroundStyle: BackgroundStyle = .classic
    
    init(width: Int, height: Int, fallingSpeedMultiplier: Double, backgroundStyle: BackgroundStyle) {
        self.width = min(MaxWidth, max(MinWidth, width))
        self.height = min(MaxHeight, max(MinHeight, height))
        self.fallingSpeedMultiplier = min(MaxFallingSpeedMultiplier, max(MinFallingSpeedMultiplier, fallingSpeedMultiplier))
        self.backgroundStyle = backgroundStyle
    }
}
