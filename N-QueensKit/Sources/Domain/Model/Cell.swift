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
    public let accessibilityLabel: String

    public init(
        position: Position,
        hasQueen: Bool,
        isConflicting: Bool
    ) {
        self.position = position
        self.hasQueen = hasQueen
        self.isConflicting = isConflicting
        self.isLightSquare = Self.calculateIsLightSquare(position: position)
        self.accessibilityIdentifier = Self.calculateAccessibilityIdentifier(
            position: position
        )
        self.accessibilityLabel = Self.calculateAccessibilityLabel(
            position: position,
            hasQueen: hasQueen,
            isConflicting: isConflicting
        )
    }
}

private extension Cell {
    static func calculateIsLightSquare(position: Position) -> Bool {
        (position.row + position.column) % 2 == 0
    }
    
    static func calculateAccessibilityIdentifier(position: Position) -> String {
        "cell_\(position.row)_\(position.column)"
    }
    
    static func calculateAccessibilityLabel(
        position: Position,
        hasQueen: Bool,
        isConflicting: Bool
    ) -> String {
        var label = "Row \(position.row + 1), Column \(position.column + 1)"
        if hasQueen {
            label += ", Queen"
        }
        if isConflicting {
            label += ", Conflicting"
        }
        return label
    }
}
