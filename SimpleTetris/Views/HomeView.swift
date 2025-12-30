import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            // 背景漸層
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(height: 80)
                
                // 標題
                Text("SimpleTetris")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 8)
                
                Spacer()
                
                // 按鈕區塊
                VStack(spacing: 24) {
                    NavigationLink(destination: GameView()) {
                        Text("開始")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.green, Color.blue]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(radius: 6)
                    }
                    
                    NavigationLink(destination: SettingsView()) {
                        Text("設定")
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
                }
                .padding(.bottom, 80)
            }
        }
    }
}
