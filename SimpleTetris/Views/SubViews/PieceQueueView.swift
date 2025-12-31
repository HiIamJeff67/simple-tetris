import SwiftUI

struct PieceQueueView: View {
    let pieces: [Piece]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(
                Array(pieces.prefix(min(MaxPieceQueueSize, pieces.count))).indices,
                id: \.self
            ) { index in
                MiniPieceView(piece: pieces[index])
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            Spacer(minLength: 0)
        }
        .frame(width: 40)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.2))
                .shadow(radius: 6)
        )
    }
}
