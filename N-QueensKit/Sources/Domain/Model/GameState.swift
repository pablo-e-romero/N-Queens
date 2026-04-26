//
//  GameState.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

public struct GameState {
    public let boardSize: Int
    public let board: [[Cell]]
    public let placedQueens: Set<Position>
    public let conflictingPositions: Set<Position>
    
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
        board: [[Cell]],
        placedQueens: Set<Position> = [],
        conflictingPositions: Set<Position> = []
    ) {
        self.boardSize = boardSize
        self.board = board
        self.placedQueens = placedQueens
        self.conflictingPositions = conflictingPositions
    }
}
