struct Piece {
    let type: PieceType
    var blocks: [Block]
    var pivot: (x: Int, y: Int)
    
    init(type: PieceType, blocks: [Block]) {
        self.type = type
        self.blocks = blocks
        switch type {
        case .I:
            // I 型通常以第二個方塊為 pivot（橫向 spawn）
            self.pivot = (x: blocks[1].x, y: blocks[1].y)
        case .O:
            // O 型不需要旋轉，但可以用左上角作 pivot
            self.pivot = (x: blocks[0].x, y: blocks[0].y)
        case .T, .S, .Z, .J, .L:
            // 一般用第一列中間的方塊作 pivot
            // 假設 spawn 是 3x2 或 2x3
            let xs = blocks.map { $0.x }
            let ys = blocks.map { $0.y }
            self.pivot = (x: xs.min()! + (xs.max()! - xs.min()!) / 2,
                          y: ys.min()! + (ys.max()! - ys.min()!) / 2)
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
