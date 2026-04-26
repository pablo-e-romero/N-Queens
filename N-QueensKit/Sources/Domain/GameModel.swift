//
//  GameModel.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import Foundation

@MainActor
public final class GameModel {
    public var state: GameState {
        GameState(
            boardSize: boardSize,
            board: boardBuilder.make(
                size: boardSize,
                placedQueens: placedQueens,
                conflictingPositions: conflictingPositionsManager.positions
            ),
            placedQueens: placedQueens,
            conflictingPositions: conflictingPositionsManager.positions
        )
    }

    private let boardSize: Int
    private var placedQueens: Set<Position>

    private let conflictingPositionsManager: ConflictingPositionsManager
    private let boardBuilder: BoardBuilder
    
    public init(
        boardSize: Int = 4,
        placedQueens: Set<Position> = [],
        conflictingPositionsManager: ConflictingPositionsManager = .init(),
        boardBuilder: BoardBuilder = .init()
    ) {
        self.boardSize = boardSize
        self.placedQueens = placedQueens
        self.conflictingPositionsManager = conflictingPositionsManager
        self.boardBuilder = boardBuilder
    }
    
    public func resetGame() {
        placedQueens.removeAll()
        conflictingPositionsManager.reset()
    }
    
    public func updatePosition(_ position: Position) {
        let containsPosition = placedQueens.contains(position)
        
        guard containsPosition || placedQueens.count < boardSize else { return }
        
        if containsPosition {
            placedQueens.remove(position)
        } else {
            placedQueens.insert(position)
        }
        
        conflictingPositionsManager.calculate(with: Array(placedQueens))
    }
}
