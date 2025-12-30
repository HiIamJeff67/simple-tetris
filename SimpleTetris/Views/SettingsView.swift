import SwiftUI

struct SettingsView: View {
    @Environment(SettingsViewModel.self) var vm

    var body: some View {
        @Bindable var vm = vm
        
        Form {
            Stepper("寬度：\(vm.settings.width)",
                    value: $vm.settings.width,
                    in: MinWidth...MaxWidth)
            Stepper("高度：\(vm.settings.height)",
                    value: $vm.settings.height,
                    in: MinHeight...MaxHeight)

            Slider(value: $vm.settings.fallingSpeedMultiplier)

            Picker("背景", selection: $vm.settings.backgroundStyle) {
                ForEach(BackgroundStyle.allCases) { style in
                    Text(style.rawValue)
                }
            }
        }
    }
}
