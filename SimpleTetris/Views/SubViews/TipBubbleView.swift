import SwiftUI

struct TipBubbleView: View {
    let text: String
    let systemImageName: String
    let isLast: Bool
    let onNext: () -> Void

    @State private var appear = false

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 20) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.35))
                            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                        VStack(spacing: 24) {
                            Image(systemName: systemImageName)
                                .font(.system(size: 44))
                                .foregroundColor(.blue)
                                .shadow(radius: 2)
                                .scaleEffect(appear ? 1 : 0.8)
                                .opacity(appear ? 1 : 0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: appear)
                            Text(text)
                                .font(.title3)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .scaleEffect(appear ? 1 : 0.8)
                                .opacity(appear ? 1 : 0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: appear)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                    .frame(maxWidth: 260, maxHeight: 200)
                    Button(isLast ? "完成" : "下一步", action: onNext)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.blue.opacity(0.85))
                        .cornerRadius(16)
                        .shadow(radius: 2)
                }
                .padding(.bottom, 80)
                Spacer()
            }
            Spacer()
        }
        .onAppear { appear = true }
        .onDisappear { appear = false }
    }
}
