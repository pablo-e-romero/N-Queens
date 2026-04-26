//
//  ConflictingPositionsManager.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Foundation

@MainActor
public final class ConflictingPositionsManager {
    private(set) var positions: Set<Position>

    public init(positions: Set<Position> = []) {
        self.positions = positions
    }
    
    func reset() {
        positions.removeAll()
    }
    
    func calculate(with placedQueens: [Position]) {
        func areConflicting(
            _ first: Position,
            _ second: Position
        ) -> Bool {
            first.row == second.row ||
            first.column == second.column ||
            abs(first.row - second.row) == abs(first.column - second.column)
        }

        positions.removeAll()

        for i in 0..<placedQueens.count {
            for j in (i + 1)..<placedQueens.count {
                let first = placedQueens[i]
                let second = placedQueens[j]
                if areConflicting(first, second) {
                    positions.insert(first)
                    positions.insert(second)
                }
            }
        }
    }
}
