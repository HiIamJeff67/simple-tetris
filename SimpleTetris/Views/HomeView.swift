import SwiftUI

struct HomeView: View {
    @State private var displaySettingView = false
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.7)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(height: 80)
                
                Text("SimpleTetris")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 8)
                
                Spacer()
                
                Image("Logo")
                    .resizable()
                    .frame(width: 240, height: 240)
                    .cornerRadius(24)
                    .shadow(radius: 8)
                    .padding(.bottom, 16)
                
                Spacer()
                
                VStack(spacing: 24) {
                    NavigationLink(destination: GameView()) {
                        Text("遊玩")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple, Color.blue]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(radius: 6)
                    }
                    
                    NavigationLink(destination: TutorialView()) {
                        Text("教學")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.green, Color.yellow]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(radius: 6)
                    }
                    
                    Button("設定") {
                        displaySettingView = true
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.orange, Color.pink]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(radius: 6)
                }
                .padding(.bottom, 80)
                .sheet(isPresented: $displaySettingView) {
                    SettingsView()
                }
            }
        }
        .onAppear {
//            MusicPlayer.shared.playMusic()
        }
    }
}
