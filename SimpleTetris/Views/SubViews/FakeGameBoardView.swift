import SwiftUI

struct FakeGameBoardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 180, height: 300)
            VStack(spacing: 2) {
                ForEach(0..<6) { _ in
                    HStack(spacing: 2) {
                        ForEach(0..<4) { _ in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.blue.opacity(0.3))
                                .frame(width: 28, height: 28)
                        }
                    }
                }
            }
            RoundedRectangle(cornerRadius: 2)
                .fill(
                    LinearGradient(
                        colors: [Color.orange, Color.yellow],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 28, height: 28)
                .offset(x: 0, y: -100)
                .shadow(color: .yellow.opacity(0.5), radius: 8, y: 4)
        }
    }
}
