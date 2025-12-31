import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("isMusicOn") private var isMusicOn: Bool = true
    @AppStorage("musicVolume") private var musicVolume: Double = 0.5
    @Query(sort: \ScoreModel.score, order: .reverse) private var scores: [ScoreModel]
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var vm: SettingsViewModel

    var body: some View {
        @Bindable var vm = vm
        
        Form {
            Section {
                Stepper(
                    "寬度：\(vm.settings.width)",
                    value: $vm.settings.width,
                    in: MinWidth...MaxWidth
                )
                .onChange(of: vm.settings.width) { _, newValue in
                    vm.updateWidth(newValue)
                }

                Stepper(
                    "高度：\(vm.settings.height)",
                    value: $vm.settings.height,
                    in: MinHeight...MaxHeight
                )
                .onChange(of: vm.settings.height) { _, newValue in
                    vm.updateHeight(newValue)
                }

            } header: {
                Label("遊戲設定", systemImage: "gamecontroller")
            } footer: {
                Text("調整遊戲棋盤的大小，會影響遊戲難度與節奏。")
            }

            Section {
                Picker("主題", selection: $themeManager.preference) {
                    ForEach(ThemePreference.allCases) { pref in
                        Text(pref.displayName)
                            .tag(pref)
                    }
                }
                .pickerStyle(.segmented)

            } header: {
                Label("外觀與主題", systemImage: "paintbrush")
            }

            Section {
                Toggle("背景音樂", isOn: $isMusicOn)
                    .onChange(of: isMusicOn) { _, newValue in
                        newValue
                        ? MusicPlayer.shared.playMusic()
                        : MusicPlayer.shared.stopMusic()
                    }

                VStack(alignment: .leading, spacing: 8) {
                    Text("音量")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Slider(
                        value: $musicVolume,
                        in: Double(MinMusicVolume)...Double(MaxMusicVolume),
                        step: 0.01
                    )
                }
                .onChange(of: musicVolume) { _, newValue in
                    MusicPlayer.shared.setVolume(Float(newValue))
                }

            } header: {
                Label("音樂與音效", systemImage: "music.note")
            }

            Section {
                if scores.isEmpty {
                    Text("尚無遊戲紀錄")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(scores) { score in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("分數：\(score.score)")
                                .font(.headline)

                            HStack {
                                Text(score.date, style: .date)
                                Spacer()
                                Text("時長：\(Int(score.duration)) 秒")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }

            } header: {
                Label("分數紀錄", systemImage: "list.number")
            }
        }
        .navigationTitle("設定")
        .background(
            Color(themeManager.isDark ? .black : .white)
                .ignoresSafeArea()
        )
        .padding()
    }
}
