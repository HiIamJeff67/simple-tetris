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
    
    mutating func rotate(isClockwise: Bool) {
        if self.type == .O { return }
        
        var newBlocks: [Block] = []
        
        if isClockwise {
            for block in self.blocks {
                let dx = block.x - pivot.x
                let dy = block.y - pivot.y
                let (newX, newY): (Int, Int)
                
                newX = pivot.x - dy
                newY = pivot.y + dx
                
                newBlocks.append(Block(x: newX, y: newY, blockColor: block.blockColor))
            }
        } else {
            for block in self.blocks {
                let dx = block.x - pivot.x
                let dy = block.y - pivot.y
                let (newX, newY): (Int, Int)
                
                newX = pivot.x + dy
                newY = pivot.y - dx
                
                newBlocks.append(Block(x: newX, y: newY, blockColor: block.blockColor))
            }
        }
        
        self.blocks = newBlocks
    }
    
    func pretendRotate(isClockwise: Bool) -> Piece {
        var result = self
        result.rotate(isClockwise: isClockwise)
        return result
    }
}
