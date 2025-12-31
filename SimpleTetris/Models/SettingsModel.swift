struct SettingsModel {
    var width: Int
    var height: Int
    var fallingSpeedMultiplier: Double
    var backgroundStyle: BackgroundStyle

    init(width: Int = 6, height: Int = 12, fallingSpeedMultiplier: Double = 1.5, backgroundStyle: BackgroundStyle = .classic) {
        self.width = min(MaxWidth, max(MinWidth, width))
        self.height = min(MaxHeight, max(MinHeight, height))
        self.fallingSpeedMultiplier = min(MaxFallingSpeedMultiplier, max(MinFallingSpeedMultiplier, fallingSpeedMultiplier))
        self.backgroundStyle = backgroundStyle
    }
}
