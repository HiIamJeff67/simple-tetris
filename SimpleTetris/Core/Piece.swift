struct Piece {
    let type: PieceType
    var blocks: [Block]
    var pivot: (x: Int, y: Int)
    
    init(type: PieceType, blocks: [Block]) {
        self.type = type
        self.blocks = blocks
        switch type {
            case .O: self.pivot = (blocks[0].x, blocks[0].y)
            case .I: self.pivot = (blocks[1].x, blocks[1].y)
            case .T, .S, .Z, .J, .L: self.pivot = (blocks[1].x, blocks[1].y)
            }
    }
}
