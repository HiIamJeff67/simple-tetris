actor GameEngine {
    let width: Int
    let height: Int
    let scorePerBlock: Int
    let maxPieceQueueSize: Int
    let pieceGenerator: PieceGenerator
    var pieceQueue: [Piece] = []
    var currentPiece: Piece
    var board: [[BlockColor?]]
    var currentScore: Int
    var isGameOver: Bool
    
    init(maxPieceQueueSize: Int, scorePerBlock: Int, settings: SettingsModel, isInitialGameOver: Bool = false) async {
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
        self.board = Array(
            repeating: Array(repeating: nil, count: width),
            count: height
        )
        self.currentScore = 0
        self.isGameOver = isInitialGameOver
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
    
    private func erasePiece(piece: Piece, isForced: Bool = false) -> Bool {
        if !isForced {
            let pieceBlockColor = piece.blocks[0].blockColor
            for block in piece.blocks {
                if !isValidBlock(block: block) || self.board[block.y][block.x] != pieceBlockColor {
                    return false
                }
            }
        }
        for block in piece.blocks {
            self.board[block.y][block.x] = nil
        }
        return true
    }
    
    private func drawPiece(piece: Piece, isForced: Bool = false) -> Bool {
        if !isForced  { // skip the check operation if is forced
            // first check if all the positions of the piece in the content is nil
            for block in piece.blocks {
                if !isValidBlock(block: block) || self.board[block.y][block.x] != nil {
                    return false
                }
            }
        }
        // then insert the piece into the content
        for block in piece.blocks {
            self.board[block.y][block.x] = block.blockColor
        }
        return true
    }
    
    func clearBoard() {
        for y in (0..<self.height).reversed() {
            for x in (0..<self.width) {
                self.board[y][x] = nil
            }
        }
    }
    
    private func clearCompletedLines() -> Int {
        var score = 0
        var newContent = self.board
        var linesCleared = 0
        
        for y in (0..<self.height).reversed() {
            let isFullLine = self.board[y].allSatisfy { $0 != nil }
            if isFullLine {
                score += self.width * self.scorePerBlock
                linesCleared += 1
            } else if linesCleared > 0 {
                newContent[y + linesCleared] = self.board[y]
            }
        }

        for y in 0..<linesCleared {
            newContent[y] = Array(repeating: nil, count: self.width)
        }

        self.board = newContent
        return score
    }
    
    private func isPieceInBoard(piece: Piece) -> Bool {
        let pieceBlockColor = piece.blocks[0].blockColor
        for block in piece.blocks {
            if !isValidBlock(block: block) || self.board[block.y][block.y] != pieceBlockColor {
                return false
            }
        }
        return true
    }
    
    func isCurrentPieceInBoard() -> Bool {
        return self.isPieceInBoard(piece: self.currentPiece)
    }
    
    private func placeDownPiece() {
        guard self.drawPiece(piece: self.currentPiece) else {
            // just to make sure the piece is drawn
            return
        }
    }
    
    private func placeNewPiece(isFirstDraw: Bool = false) {
        if self.isGameOver {
            end()
            return
        }
        guard self.drawPiece(piece: self.currentPiece, isForced: isFirstDraw) else {
            self.isGameOver = true
            return
        }
    }
    
    private func getNextPiece() {
        guard !pieceQueue.isEmpty else {
            print("Piece queue empty!");
            return
        }
        self.currentPiece = pieceQueue.removeFirst()
    }
    
    func start() {
        self.isGameOver = false
        self.clearBoard()
        self.placeNewPiece(isFirstDraw: true)
    }
    
    func end() {
        while !self.pieceQueue.isEmpty {
            _ = pieceQueue.removeFirst()
        }
    }
    
    private func isMovable(piece: Piece, dx: Int, dy: Int) -> Bool {
        for block in piece.blocks {
            let newX = block.x + dx
            let newY = block.y + dy
            if newX < 0 || newX >= self.width || newY < 0 || newY >= self.height || self.board[newY][newX] != nil {
                return false
            }
        }
        return true
    }
    
    func isLeftMovable() -> Bool {
        return self.isMovable(piece: self.currentPiece, dx: -1, dy: 0)
    }
    
    func isRightMovable() -> Bool {
        return self.isMovable(piece: self.currentPiece, dx: 1, dy: 0)
    }
    
    func isDownMovable() -> Bool {
        return self.isMovable(piece: self.currentPiece, dx: 0, dy: 1)
    }
    
    func directlyMove(dx: Int, dy: Int) {
        for i in self.currentPiece.blocks.indices {
            self.currentPiece.blocks[i].x += dx
            self.currentPiece.blocks[i].y += dy
        }
        self.currentPiece.pivot.x += dx
        self.currentPiece.pivot.y += dy
    }
    
    func moveLeft() -> Bool {
        if self.isGameOver { return false }
        
        // note that we have to FIRST erase the piece,
        // so that the next position of the piece will not always conflict with the previous position
        guard self.erasePiece(piece: self.currentPiece) else {
            print("Failed to erase piece, please try to reset the game")
            return false
        }
        
        if !isLeftMovable() {
            guard self.drawPiece(piece: self.currentPiece) else { // remember to draw back the original piece if unmovable
                print("Failed to draw piece, please try to reset the game")
                return false
            }
            return false
        }
        
        self.directlyMove(dx: -1, dy: 0)
        
        guard self.drawPiece(piece: self.currentPiece) else {
            print("Failed to draw piece, please try to reset the game")
            return false
        }
        
        return true
    }
    
    func moveRight() -> Bool {
        if self.isGameOver { return false }
        
        // note that we have to FIRST erase the piece,
        // so that the next position of the piece will not always conflict with the previous position
        guard self.erasePiece(piece: self.currentPiece) else {
            print("Failed to erase piece, please try to reset the game")
            return false
        }
        
        if !isRightMovable() {
            guard self.drawPiece(piece: self.currentPiece) else { // remember to draw back the original piece if unmovable
                print("Failed to draw piece, please try to reset the game")
                return false
            }
            return false
        }
        
        self.directlyMove(dx: 1, dy: 0)
        
        guard self.drawPiece(piece: self.currentPiece) else {
            print("Failed to draw piece, please try to reset the game")
            return false
        }
        
        return true
    }
    
    func moveDown() async -> Bool {
        if self.isGameOver { return false }
        
        // note that we have to FIRST erase the piece,
        // so that the next position of the piece will not always conflict with the previous position
        guard self.erasePiece(piece: self.currentPiece) else {
            print("Failed to erase piece, please try to reset the game")
            return false
        }
        
        if !isDownMovable() {
            self.placeDownPiece()
            if !self.isGameOver { // the score will only update if the game is not over
                self.currentScore += self.clearCompletedLines()
            }
            self.refillPieceQueue()
            self.getNextPiece()
            self.placeNewPiece()
            return false
        }

        self.directlyMove(dx: 0, dy: 1)
        
        guard self.drawPiece(piece: self.currentPiece) else {
            print("Failed to draw piece, please try to reset the game")
            return false
        }

        return true
    }
    
    private func directlyRotate(isClockwise: Bool) {
        if self.currentPiece.type == .O { return }
        
        var newBlocks: [Block] = []
        
        if isClockwise {
            for block in self.currentPiece.blocks {
                let dx = block.x - self.currentPiece.pivot.x
                let dy = block.y - self.currentPiece.pivot.y
                let (newX, newY): (Int, Int)
                
                newX = self.currentPiece.pivot.x - dy
                newY = self.currentPiece.pivot.y + dx
                
                newBlocks.append(Block(x: newX, y: newY, blockColor: block.blockColor))
            }
        } else {
            for block in self.currentPiece.blocks {
                let dx = block.x - self.currentPiece.pivot.x
                let dy = block.y - self.currentPiece.pivot.y
                let (newX, newY): (Int, Int) = (
                    self.currentPiece.pivot.x + dy,
                    self.currentPiece.pivot.y - dx
                )
                
                newBlocks.append(Block(x: newX, y: newY, blockColor: block.blockColor))
            }
        }
        
        self.currentPiece.blocks = newBlocks
    }
    
    private func rotateUntilProperly(isClockwise: Bool) -> Bool {
        // note that we have to FIRST erase the piece,
        // so that the next position of the piece will not always conflict with the previous position
        guard self.erasePiece(piece: self.currentPiece) else {
            print("Failed to erase piece, please try to reset the game")
            return false
        }
        
        for _ in 0..<4 {
            self.directlyRotate(isClockwise: isClockwise)
            if isValidePiece(piece: self.currentPiece) {
                guard self.drawPiece(piece: self.currentPiece) else {
                    print("Failed to draw piece, please try to reset the game")
                    return false
                }
                return true
            }
        }
        
        guard self.drawPiece(piece: self.currentPiece) else {
            print("Failed to draw piece, please try to reset the game")
            return false
        }
        return false
    }
    
    func rotateClockwise() -> Bool {
        if self.isGameOver { return false }
        
        return self.rotateUntilProperly(isClockwise: true)
    }
    
    func rotateCounterClockwise() -> Bool {
        if self.isGameOver { return false }
        
        return self.rotateUntilProperly(isClockwise: false)
    }
    
    func getContent() -> GameContent {
        return GameContent(
            board: self.board,
            score: self.currentScore,
            currentPiece: self.currentPiece,
            pieceQueue: self.pieceQueue,
            isGameOver: false
        )
    }
}

