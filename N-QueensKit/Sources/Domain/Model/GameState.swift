//
//  GameState.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

public struct GameState {
    public let boardSize: Int
    public var placedQueens: Set<Position>
    public var conflictingPositions: Set<Position>
    
    public var placedQueensCount: Int {
        placedQueens.count
    }
    
    public var hasConflicts: Bool {
        !conflictingPositions.isEmpty
    }
    
    public var won: Bool {
        placedQueens.count == boardSize &&
        conflictingPositions.isEmpty
    }
    
    public init(
        boardSize: Int,
        placedQueens: Set<Position> = [],
        conflictingPositions: Set<Position> = []
    ) {
        self.boardSize = boardSize
        self.placedQueens = placedQueens
        self.conflictingPositions = conflictingPositions
    }
    
    mutating func reset() {
        placedQueens.removeAll()
        conflictingPositions.removeAll()
    }
}
