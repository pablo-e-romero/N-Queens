//
//  Cell.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

public struct Cell {
    public let position: Position
    public let hasQueen: Bool
    public let isConflicting: Bool
    public let isLightSquare: Bool
    public let accessibilityIdentifier: String

    public var accessibilityLabel: String {
        var label = "Row \(position.row + 1), Column \(position.column + 1)"
        if hasQueen {
            label += ", Queen"
        }
        if isConflicting {
            label += ", Conflicting"
        }
        return label
    }

    public init(
        position: Position = .init(row: 0, column: 0),
        hasQueen: Bool,
        isConflicting: Bool,
        isLightSquare: Bool,
        accessibilityIdentifier: String = "",

    ) {
        self.position = position
        self.hasQueen = hasQueen
        self.isConflicting = isConflicting
        self.isLightSquare = isLightSquare
        self.accessibilityIdentifier = accessibilityIdentifier
    }
    
    init(
        row: Int,
        column: Int,
        hasQueen: Bool,
        isConflicting: Bool
    ) {
        self.init(
            position: Position(row: row, column: column),
            hasQueen: hasQueen,
            isConflicting: isConflicting,
            isLightSquare: (row + column) % 2 == 0,
            accessibilityIdentifier: "cell_\(row)_\(column)"
        )
    }
}
