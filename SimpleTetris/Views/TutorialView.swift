import SwiftUI

struct TutorialView: View {
    @State private var tipStep = 0
    private let tips = [
        ("左右滑動螢幕可移動方塊", "arrow.left.and.right"),
        ("輕按螢幕可旋轉方塊", "hand.tap"),
        ("長按螢幕可讓方塊直接落到底", "hand.point.up.left.fill"),
        ("分數會自動儲存，可在設定頁查看", "list.number")
    ]

    var body: some View {
        ZStack {
            Color.blue.opacity(0.7)
                .ignoresSafeArea()
                .zIndex(0)
            
            VStack(spacing: 24) {
                Text("操作教學")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 32)

                FakeGameBoardView()
                    .padding(.bottom, 8)

                TutorialInstructionListView()
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .shadow(radius: 8)
                    .animation(.easeInOut(duration: 0.4), value: tipStep)
                Spacer()
            }
            .padding()
            .opacity(tipStep < tips.count ? 0.5 : 1)
            .blur(radius: tipStep < tips.count ? 8 : 0)
            .zIndex(1)

            if tipStep < tips.count {
                TipBubbleView(
                    text: tips[tipStep].0,
                    systemImageName: tips[tipStep].1,
                    isLast: tipStep == tips.count - 1,
                    onNext: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            tipStep += 1
                        }
                    }
                )
                .transition(.scale.combined(with: .opacity))
                .zIndex(2)
            }
        }
    }
}
