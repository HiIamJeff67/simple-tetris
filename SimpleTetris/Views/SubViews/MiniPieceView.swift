import SwiftUI

struct MiniPieceView: View {
    let piece: Piece
    let cellSize: CGFloat = 8
    private let gridSize = 4

    var body: some View {
        let blocks = piece.blocks

        let minX = blocks.map(\.x).min() ?? 0
        let minY = blocks.map(\.y).min() ?? 0
        let maxX = blocks.map(\.x).max() ?? 0
        let maxY = blocks.map(\.y).max() ?? 0

        let width = maxX - minX + 1
        let height = maxY - minY + 1

        let offsetX = (gridSize - width) / 2
        let offsetY = (gridSize - height) / 2

        ZStack(alignment: .topLeading) {
            ForEach(blocks, id: \.self) { block in
                Rectangle()
                    .fill(block.blockColor.getUIColor())
                    .frame(width: cellSize, height: cellSize)
                    .position(
                        x: CGFloat(block.x - minX + offsetX) * cellSize + cellSize / 2,
                        y: CGFloat(block.y - minY + offsetY) * cellSize + cellSize / 2
                    )
            }
        }
        .frame(
            width: CGFloat(gridSize) * cellSize,
            height: CGFloat(gridSize) * cellSize
        )
    }
}
