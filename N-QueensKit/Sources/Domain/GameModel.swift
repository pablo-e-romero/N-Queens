//
//  GameModel.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import Foundation

@MainActor
public final class GameModel {
    public private(set) var state: GameState
    
    public init(state: GameState) {
        self.state = state
    }
    
    public convenience init(boardSize: Int) {
        self.init(state: GameState(boardSize: boardSize))
    }
    
    public func resetGame() {
        state.reset()
    }
    
    public func updatePosition(_ position: Position) {
        state.placedQueens = calculatePlacedQueensByUpdatingPosition(
            position,
            placedQueens: state.placedQueens,
            boardSize: state.boardSize
        )
        
        state.conflictingPositions = calculateConflictingPositions(
            with: Array(state.placedQueens)
        )
    }
}

private extension GameModel {
    func calculatePlacedQueensByUpdatingPosition(
        _ position: Position,
        placedQueens: Set<Position>,
        boardSize: Int
    ) -> Set<Position> {
        var mutatablePlacedQueens = placedQueens
        
        let containsPosition = mutatablePlacedQueens.contains(position)
        
        guard
            containsPosition || mutatablePlacedQueens.count < boardSize
        else {
            return placedQueens
        }
        
        if containsPosition {
            mutatablePlacedQueens.remove(position)
        } else {
            mutatablePlacedQueens.insert(position)
        }
        
        return mutatablePlacedQueens
    }
    
    func calculateConflictingPositions(
        with placedQueens: [Position]
    ) -> Set<Position> {
        func areConflicting(
            _ first: Position,
            _ second: Position
        ) -> Bool {
            first.row == second.row ||
            first.column == second.column ||
            abs(first.row - second.row) == abs(first.column - second.column)
        }
        
        var positions: Set<Position> = []

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
        
        return positions
    }
}
