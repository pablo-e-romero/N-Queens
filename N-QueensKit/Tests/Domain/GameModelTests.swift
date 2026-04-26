//
//  GameModelTests.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Testing
@testable import Domain

@MainActor
struct GameModelTests {

    // MARK: - Initial state

    @Test func initialStateIsEmpty() {
        let sut = GameModel(boardSize: 4)
        #expect(sut.state.boardSize == 4)
        #expect(sut.state.placedQueensCount == 0)
        #expect(!sut.state.hasConflicts)
        #expect(!sut.state.won)
    }

    // MARK: - Placing queens

    @Test func placingQueenUpdatesState() {
        let sut = GameModel(boardSize: 4)
        sut.updatePosition(Position(row: 0, column: 0))
        #expect(sut.state.placedQueensCount == 1)
        #expect(sut.state.placedQueens.contains(Position(row: 0, column: 0)))
    }

    @Test func tappingQueenAgainRemovesIt() {
        let sut = GameModel(boardSize: 4)
        let pos = Position(row: 1, column: 1)
        sut.updatePosition(pos)
        sut.updatePosition(pos)
        #expect(sut.state.placedQueensCount == 0)
    }

    @Test func cannotExceedBoardSizeLimit() {
        let sut = GameModel(boardSize: 4)
        // Fill all 4 slots with the known valid solution
        sut.updatePosition(Position(row: 0, column: 1))
        sut.updatePosition(Position(row: 1, column: 3))
        sut.updatePosition(Position(row: 2, column: 0))
        sut.updatePosition(Position(row: 3, column: 2))
        // Trying to add a 5th queen at an unoccupied cell is ignored
        sut.updatePosition(Position(row: 0, column: 0))
        #expect(sut.state.placedQueensCount == 4)
    }

    // MARK: - Conflicts

    @Test func conflictsAreDetectedOnSameRow() {
        let sut = GameModel(boardSize: 4)
        sut.updatePosition(Position(row: 0, column: 0))
        sut.updatePosition(Position(row: 0, column: 2))
        #expect(sut.state.hasConflicts)
    }

    @Test func removingOneConflictingQueenClearsConflicts() {
        let sut = GameModel(boardSize: 4)
        sut.updatePosition(Position(row: 0, column: 0))
        sut.updatePosition(Position(row: 0, column: 2))
        sut.updatePosition(Position(row: 0, column: 2)) // remove
        #expect(!sut.state.hasConflicts)
    }

    // MARK: - Reset

    @Test func resetClearsAllQueensAndConflicts() {
        let sut = GameModel(boardSize: 4)
        sut.updatePosition(Position(row: 0, column: 0))
        sut.updatePosition(Position(row: 0, column: 1))
        sut.resetGame()
        #expect(sut.state.placedQueensCount == 0)
        #expect(!sut.state.hasConflicts)
    }

    @Test func resetPreservesBoardSize() {
        let sut = GameModel(boardSize: 6)
        sut.resetGame()
        #expect(sut.state.boardSize == 6)
    }

    // MARK: - Win condition

    @Test func winConditionIsMet() {
        let sut = GameModel(boardSize: 4)
        sut.updatePosition(Position(row: 0, column: 1))
        sut.updatePosition(Position(row: 1, column: 3))
        sut.updatePosition(Position(row: 2, column: 0))
        sut.updatePosition(Position(row: 3, column: 2))
        #expect(sut.state.won)
    }

    @Test func notWonWithAllQueensConflicting() {
        let sut = GameModel(boardSize: 4)
        sut.updatePosition(Position(row: 0, column: 0))
        sut.updatePosition(Position(row: 0, column: 1))
        sut.updatePosition(Position(row: 0, column: 2))
        sut.updatePosition(Position(row: 0, column: 3))
        #expect(!sut.state.won)
    }

    @Test func notWonWithFewerQueensThanBoardSize() {
        let sut = GameModel(boardSize: 4)
        sut.updatePosition(Position(row: 0, column: 1))
        sut.updatePosition(Position(row: 1, column: 3))
        #expect(!sut.state.won)
    }
}
