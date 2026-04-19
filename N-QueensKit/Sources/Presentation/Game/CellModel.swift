//
//  CellModel.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

struct CellModel {
    let row: Int
    let column: Int
    var hasQueen: Bool
    var isConflicting: Bool
    let isLightSquare: Bool
    let accessibilityIdentifier: String

    init(
        row: Int,
        column: Int,
        hasQueen: Bool,
        isConflicting: Bool,
        isLightSquare: Bool,
        accessibilityIdentifier: String = "",

    ) {
        self.row = row
        self.column = column
        self.hasQueen = hasQueen
        self.isConflicting = isConflicting
        self.isLightSquare = isLightSquare
        self.accessibilityIdentifier = accessibilityIdentifier
    }
    
    init(row: Int, column: Int) {
        self.init(
            row: row,
            column: column,
            hasQueen: false,
            isConflicting: false,
            isLightSquare: (row + column) % 2 == 0,
            accessibilityIdentifier: "cell_\(row)_\(column)"
        )
    }
    
    var accessibilityLabel: String {
        var label = "Row \(row + 1), Column \(column + 1)"
        if hasQueen {
            label += ", Queen"
        }
        if isConflicting {
            label += ", Conflicting"
        }
        return label
    }
    
//        hasQueen: boardState.hasQueen(at: position),
//        isConflicting: conflicts.isConflicting(position),
}
