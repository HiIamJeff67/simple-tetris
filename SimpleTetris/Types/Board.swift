actor Board {
    let width: Int
    let height: Int
    let scorePerBlock: Int
    let maxPieceQueueSize: Int
    let pieceGenerator: PieceGenerator
    var pieceQueue: [Piece] = []
    var currentPiece: Piece
    var content: [[BlockColor?]]
    var currentScore: Int
    
    init(maxPieceQueueSize: Int, scorePerBlock: Int, settings: SettingsModel) async {
        self.width = settings.width
        self.height = settings.height
        self.scorePerBlock = scorePerBlock
        self.maxPieceQueueSize = maxPieceQueueSize + 1 // since we always extract one piece as the current piece after filling the piece queue
        self.pieceGenerator = await PieceGenerator()
        for _ in 0..<self.maxPieceQueueSize {
            let generatedPiece = await self.pieceGenerator.generateRandomPiece(at: ( width / 2 - 2, 0))
            self.pieceQueue.append(generatedPiece)
        }
        self.currentPiece = pieceQueue.removeFirst()
        self.content = Array(
            repeating: Array(repeating: nil, count: width),
            count: height
        )
        self.currentScore = 0
    }
    
    // private methods
    private func refillPieceQueue() {
        Task {
            while self.pieceQueue.count < self.maxPieceQueueSize {
                await self.pieceQueue.append(self.pieceGenerator.generateRandomPiece(at: ( width / 2 - 2, 0)))
            }
        }
    }
    
    private func isValidBlock(block: Block) -> Bool {
        return block.x >= 0 && block.x < self.width && block.y >= 0 && block.y < self.height
    }
    
    private func isValidePiece(piece: Piece) -> Bool {
        for block in piece.blocks {
            if !isValidBlock(block: block) {
                return false
            }
        }
        return true
    }
    
    private func erasePiece(piece: Piece) -> Bool {
        for block in piece.blocks {
//            print("erasePiece: block=(x:\(block.x), y:\(block.y)), color=\(String(describing: block.blockColor)), content=\(String(describing: self.content[block.y][block.x]))")
            if !isValidBlock(block: block){
//                print("erasePiece failed at (x:\(block.x), y:\(block.y)), expected color=\(String(describing: block.blockColor)), found=\(String(describing: self.content[block.y][block.x]))")
                return false
            }
        }
        for block in piece.blocks {
            self.content[block.y][block.x] = nil
        }
        return true
    }
    
    private func drawPiece(piece: Piece) -> Bool {
        // first check if all the positions of the piece in the content is nil
        for block in piece.blocks {
//            print("drawPiece: block=(x:\(block.x), y:\(block.y)), color=\(String(describing: block.blockColor)), content=\(String(describing: self.content[block.y][block.x]))")
            if !isValidBlock(block: block) {
//                print("drawPiece failed at (x:\(block.x), y:\(block.y)), found=\(String(describing: self.content[block.y][block.x]))")
                return false
            }
        }
        // then insert the piece into the content
        for block in piece.blocks {
            self.content[block.y][block.x] = block.blockColor
        }
        return true
    }
    
    private func clearCompletedLines() -> Int {
        var score = 0
        var newContent = content

        var linesCleared = 0
        for y in (0..<height).reversed() {
            let isFullLine = content[y].allSatisfy { $0 != nil }
            if isFullLine {
                score += width * scorePerBlock
                linesCleared += 1
            } else if linesCleared > 0 {
                newContent[y + linesCleared] = content[y]
            }
        }

        for y in 0..<linesCleared {
            newContent[y] = Array(repeating: nil, count: width)
        }

        content = newContent
        return score
    }
    
    private func placeDownPiece() {
        if !self.drawPiece(piece: self.currentPiece) {
            // just to make sure the piece is drawn
        }
    }
    
    private func placeNewPiece() {
        if !self.drawPiece(piece: self.currentPiece) {
            print("Failed to draw piece, please try to reset the game")
        }
    }
    
    private func getNextPiece() {
        guard !pieceQueue.isEmpty else {
            print("Piece queue empty!");
            return
        }
        self.currentPiece = pieceQueue.removeFirst()
    }
    
    // public methods
    func printCurrentContent() {
        print(self.content)
    }
    
    func initialize() {
        self.placeNewPiece()
    }
    
    private func isPlacable(dx: Int, dy: Int) -> Bool {
        for block in self.currentPiece.blocks {
            let newX = block.x + dx
            let newY = block.y + dy
            if newX < 0 || newX >= self.width || newY < 0 || newY >= self.height || self.content[newY][newX] != nil {
                return false
            }
        }
        return true
    }
    
    func isLeftPlacable() -> Bool {
        return self.isPlacable(dx: -1, dy: 0)
    }
    
    func isRightPlacable() -> Bool {
        return self.isPlacable(dx: 1, dy: 0)
    }
    
    func isDownPlacable() -> Bool {
        return self.isPlacable(dx: 0, dy: 1)
    }
    
    func move(dx: Int, dy: Int) {
        for i in self.currentPiece.blocks.indices {
            self.currentPiece.blocks[i].x += dx
            self.currentPiece.blocks[i].y += dy
        }
        self.currentPiece.pivot.x += dx
        self.currentPiece.pivot.y += dy
    }
    
    func moveLeft() -> Bool {
        if !isLeftPlacable() { return false }
        
        if !self.erasePiece(piece: self.currentPiece) {
            print("Failed to erase piece, please try to reset the game")
            return false
        }
        self.move(dx: -1, dy: 0)
        if !self.drawPiece(piece: self.currentPiece) {
            print("Failed to draw piece, please try to reset the game")
            return false
        }
        
        return true
    }
    
    func moveRight() -> Bool {
        if !isRightPlacable() { return false }
        
        if !self.erasePiece(piece: self.currentPiece) {
            print("Failed to erase piece, please try to reset the game")
            return false
        }
        self.move(dx: 1, dy: 0)
        if !self.drawPiece(piece: self.currentPiece) {
            print("Failed to draw piece, please try to reset the game")
            return false
        }
        
        return true
    }
    
    func moveDown() async -> Bool {
        guard erasePiece(piece: currentPiece) else { return false }
        
        if !isDownPlacable() {
            placeDownPiece()
            currentScore += clearCompletedLines()
            refillPieceQueue()
            getNextPiece()
            placeNewPiece()
            return false
        }

        self.move(dx: 0, dy: 1)
        guard drawPiece(piece: currentPiece) else { return false }

        return true
    }
    
    private func rotate(isClockwise: Bool) -> Task<Bool, Never> {
        Task {
            for _ in 0..<4 {
                let rotatedPiece = await self.currentPiece.pretendRotate(isClockwise: isClockwise)
                if !isValidePiece(piece: rotatedPiece) {
                    return false
                }
                self.currentPiece = rotatedPiece
            }
            return true
        }
    }
    
    func rotateClockwise() -> Task<Bool, Never> {
        return self.rotate(isClockwise: true)
    }
    
    func rotateCounterClockwise() -> Task<Bool, Never> {
        return self.rotate(isClockwise: false)
    }
    
    func getContent() -> BoardContent {
        return BoardContent(
            grid: self.content,
            score: self.currentScore,
            currentPiece: self.currentPiece,
            isGameOver: false
        )
    }
}

