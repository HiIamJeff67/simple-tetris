struct PieceGenerator {
    private let allPieceTypes: [PieceType]
    private let allPieceBlockColors: [BlockColor]
    
    init() {
        self.allPieceTypes = PieceType.allCases
        self.allPieceBlockColors = BlockColor.allCases
    }
    
    func generateRandomPiece(at: (x: Int, y: Int)) -> Piece {
        guard let randomPieceBlockColor = allPieceBlockColors.randomElement() else {
            print("No piece block colors available")
            return Piece(type: .I, blocks: PieceType.I.shapedBlock.map() { cord in
                Block(x: at.x + cord.0, y: at.y + cord.1, blockColor: .blue)
            })
        }
        guard let randomPieceType = allPieceTypes.randomElement() else {
            print("No piece types available")
            return Piece(type: .I, blocks: PieceType.I.shapedBlock.map() { cord in
                Block(x: at.x + cord.0, y: at.y + cord.1, blockColor: .blue)
            })
        }
        let generatedBlocks: [Block] = randomPieceType.shapedBlock.map() { cord in
            Block(x: at.x + cord.0, y: at.y + cord.1, blockColor: randomPieceBlockColor)
        }
        return Piece(type: randomPieceType, blocks: generatedBlocks)
    }
}
