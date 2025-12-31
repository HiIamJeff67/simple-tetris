import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("isMusicOn") private var isMusicOn: Bool = true
    @AppStorage("musicVolume") private var musicVolume: Double = 0.5
    @Query(sort: \ScoreModel.score, order: .reverse) var scores: [ScoreModel]
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var vm: SettingsViewModel

    var body: some View {
        @Bindable var vm = vm
        
        Form {
            Stepper("寬度：\(vm.settings.width)",
                    value: $vm.settings.width,
                    in: MinWidth...MaxWidth)
                .onChange(of: vm.settings.width) { _, newValue in
                    vm.updateWidth(newValue)
                }
            Stepper("高度：\(vm.settings.height)",
                    value: $vm.settings.height,
                    in: MinHeight...MaxHeight)
                .onChange(of: vm.settings.height) { _, newValue in
                    vm.updateHeight(newValue)
                }

            Picker("背景", selection: $vm.settings.backgroundStyle) {
                ForEach(BackgroundStyle.allCases) { style in
                    Text(style.rawValue)
                }
            }
            Picker("主題", selection: $themeManager.preference) {
                ForEach(ThemePreference.allCases) { pref in
                    Text(pref.displayName).tag(pref)
                }
            }
            .pickerStyle(.segmented)
            
            Toggle("背景音樂", isOn: $isMusicOn)
                .onChange(of: isMusicOn) { _, newValue in
                    if newValue {
                        MusicPlayer.shared.playMusic()
                    } else {
                        MusicPlayer.shared.stopMusic()
                    }
                }
            Slider(value: $musicVolume, in: Double(MinMusicVolume)...Double(MaxMusicVolume), step: 0.01) {
                Text("音量")
            }
            .onChange(of: musicVolume) { _, newValue in
                MusicPlayer.shared.setVolume(Float(newValue))
            }
            
            VStack {
                Text("分數紀錄")
                    .font(.title2)
                    .padding(.top)
                List(scores) { score in
                    HStack {
                        Text("分數：\(score.score)")
                        Spacer()
                        Text(score.date, style: .date)
                            .foregroundColor(.gray)
                            .font(.caption)
                        Text("時長：\(Int(score.duration)) 秒")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
            }
        }
        .id(scores.count)
        .background(Color(themeManager.isDark ? .black : .white))
    }
}
