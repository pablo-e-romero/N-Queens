//
//  GameStateTests.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Testing
@testable import Domain

@MainActor struct GameStateTests {

    // MARK: - Initial values

    @Test func defaultInitHasNoQueensOrConflicts() {
        let sut = GameState(boardSize: 4)
        #expect(sut.boardSize == 4)
        #expect(sut.placedQueensCount == 0)
        #expect(!sut.hasConflicts)
        #expect(!sut.won)
    }

    // MARK: - placedQueensCount

    @Test func placedQueensCountMatchesSetSize() {
        let queens: Set<Position> = [Position(row: 0, column: 0), Position(row: 1, column: 2)]
        let sut = GameState(boardSize: 4, placedQueens: queens)
        #expect(sut.placedQueensCount == 2)
    }

    // MARK: - hasConflicts

    @Test func hasConflictsTrueWhenConflictsPresent() {
        let sut = GameState(
            boardSize: 4,
            conflictingPositions: [Position(row: 0, column: 0)]
        )
        #expect(sut.hasConflicts)
    }

    @Test func hasConflictsFalseWithEmptyConflicts() {
        let sut = GameState(boardSize: 4, conflictingPositions: [])
        #expect(!sut.hasConflicts)
    }

    // MARK: - won

    @Test func wonRequiresBoardSizeQueensWithNoConflicts() {
        let queens: Set<Position> = [
            Position(row: 0, column: 1),
            Position(row: 1, column: 3),
            Position(row: 2, column: 0),
            Position(row: 3, column: 2)
        ]
        let sut = GameState(boardSize: 4, placedQueens: queens, conflictingPositions: [])
        #expect(sut.won)
    }

    @Test func notWonWhenFewerQueensThanBoardSize() {
        let queens: Set<Position> = [Position(row: 0, column: 1), Position(row: 1, column: 3)]
        let sut = GameState(boardSize: 4, placedQueens: queens, conflictingPositions: [])
        #expect(!sut.won)
    }

    @Test func notWonWhenBoardSizeReachedButConflictsExist() {
        let queens: Set<Position> = [
            Position(row: 0, column: 0),
            Position(row: 0, column: 1),
            Position(row: 0, column: 2),
            Position(row: 0, column: 3)
        ]
        let conflict: Set<Position> = [Position(row: 0, column: 0)]
        let sut = GameState(boardSize: 4, placedQueens: queens, conflictingPositions: conflict)
        #expect(!sut.won)
    }
}
