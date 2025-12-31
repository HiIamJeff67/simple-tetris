import Foundation
import SwiftUI

struct GameContent {
    var board: [[BlockColor?]] = Array(repeating: Array(repeating: nil, count: 10), count: 20)
    var score: Int = 0
    var currentPiece: Piece? = nil
    var isGameOver: Bool = false
}
