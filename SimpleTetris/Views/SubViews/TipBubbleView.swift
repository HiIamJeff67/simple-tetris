import SwiftUI

struct TipBubbleView: View {
    let text: String
    let isLast: Bool
    let onNext: () -> Void

    @State private var appear = false

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 16) {
                    Text(text)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 20)
                        .background(
                            LinearGradient(
                                colors: [Color.purple, Color.blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(color: .purple.opacity(0.3), radius: 12, y: 6)
                        .scaleEffect(appear ? 1 : 0.8)
                        .opacity(appear ? 1 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: appear)

                    Button(isLast ? "完成" : "下一步", action: onNext)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [Color.green, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(radius: 4)
                }
                .padding(.bottom, 80)
                Spacer()
            }
            Spacer()
        }
        .onAppear {
            appear = true
        }
        .onDisappear {
            appear = false
        }
    }
}
