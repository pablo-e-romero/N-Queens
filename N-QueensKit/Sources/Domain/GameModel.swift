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
    private var placedQueens: Set<Position>
    private let conflictingPositionsManager: ConflictingPositionsManager
    
    public init(
        boardSize: Int,
        placedQueens: Set<Position> = [],
        conflictingPositionsManager: ConflictingPositionsManager = .init(),
    ) {
        self.placedQueens = placedQueens
        self.conflictingPositionsManager = conflictingPositionsManager
        
        state = GameState(
            boardSize: boardSize,
            placedQueens: placedQueens,
            conflictingPositions: conflictingPositionsManager.positions
        )
    }
    
    public func resetGame() {
        placedQueens.removeAll()
        conflictingPositionsManager.reset()
        
        state = GameState(
            boardSize: state.boardSize,
            placedQueens: placedQueens,
            conflictingPositions: conflictingPositionsManager.positions
        )
    }
    
    public func updatePosition(_ position: Position) {
        let containsPosition = placedQueens.contains(position)
        
        guard
            containsPosition || placedQueens.count < state.boardSize
        else {
            return
        }
        
        if containsPosition {
            placedQueens.remove(position)
        } else {
            placedQueens.insert(position)
        }
        
        conflictingPositionsManager.calculate(with: Array(placedQueens))
        
        state = GameState(
            boardSize: state.boardSize,
            placedQueens: placedQueens,
            conflictingPositions: conflictingPositionsManager.positions
        )
    }
}
