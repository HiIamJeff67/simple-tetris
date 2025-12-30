enum PieceType: CaseIterable, Sendable {
    case I, O, T, S, Z, J, L
}

extension PieceType: Equatable { // force to tell swift this comparasion is NOT relate to any actor action
    nonisolated static func == (lhs: PieceType, rhs: PieceType) -> Bool {
        switch (lhs, rhs) {
        case (.I,.I), (.O,.O), (.T,.T),
             (.S,.S), (.Z,.Z), (.J,.J), (.L,.L):
            return true
        default:
            return false
        }
    }
}

extension PieceType {
    var shapedBlock: [(Int, Int)] {
        switch self {
        case .I:
            // I type: ####
            return [
                (0, 0), (1, 0), (2, 0), (3, 0)
            ]
        case .O:
            // O type: ##
            //         ##
            return [
                (0, 0), (1, 0),
                (0, 1), (1, 1)
            ]
        case .T:
            // T type: ###
            //          #
            return [
                (0, 0), (1, 0), (2, 0),
                        (1, 1)
            ]
        case .S:
            // S type:  ##
            //         ##
            return [
                        (1, 0), (2, 0),
                (0, 1), (1, 1)
            ]
        case .Z:
            // Z type: ##
            //          ##
            return [
                (0, 0), (1, 0),
                        (1, 1), (2, 1),
            ]
        case .J:
            // J type: ###
            //           #
            return [
                (0, 0), (1, 0), (2, 0),
                                (2, 1)
            ]
        case .L:
            // L type: ###
            //         #
            return [
                (0, 0), (1, 0), (2, 0),
                (0, 1)
            ]
        }
    }
}
