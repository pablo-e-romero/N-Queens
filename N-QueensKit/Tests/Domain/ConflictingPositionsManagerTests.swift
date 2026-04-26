//
//  ConflictingPositionsManagerTests.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Testing
@testable import Domain

@MainActor
struct ConflictingPositionsManagerTests {
    let sut = ConflictingPositionsManager()

    @Test func noConflictsForEmptyBoard() {
        sut.calculate(with: [])
        #expect(sut.positions.isEmpty)
    }

    @Test func noConflictsForSingleQueen() {
        sut.calculate(with: [Position(row: 0, column: 0)])
        #expect(sut.positions.isEmpty)
    }

    @Test func detectsSameRowConflict() {
        sut.calculate(with: [Position(row: 0, column: 0), Position(row: 0, column: 3)])
        #expect(sut.positions.contains(Position(row: 0, column: 0)))
        #expect(sut.positions.contains(Position(row: 0, column: 3)))
    }

    @Test func detectsSameColumnConflict() {
        sut.calculate(with: [Position(row: 0, column: 2), Position(row: 3, column: 2)])
        #expect(sut.positions.contains(Position(row: 0, column: 2)))
        #expect(sut.positions.contains(Position(row: 3, column: 2)))
    }

    @Test func detectsDiagonalConflict() {
        sut.calculate(with: [Position(row: 0, column: 0), Position(row: 2, column: 2)])
        #expect(sut.positions.count == 2)
    }

    @Test func detectsAntiDiagonalConflict() {
        sut.calculate(with: [Position(row: 0, column: 3), Position(row: 3, column: 0)])
        #expect(sut.positions.count == 2)
    }

    @Test func noConflictsForValidFourQueensSolution() {
        let queens = [
            Position(row: 0, column: 1),
            Position(row: 1, column: 3),
            Position(row: 2, column: 0),
            Position(row: 3, column: 2),
        ]
        sut.calculate(with: queens)
        #expect(sut.positions.isEmpty)
    }

    @Test func resetClearsAllConflicts() {
        sut.calculate(with: [Position(row: 0, column: 0), Position(row: 0, column: 1)])
        sut.reset()
        #expect(sut.positions.isEmpty)
    }

    @Test func recalculateAfterResetReflectsNewQueens() {
        sut.calculate(with: [Position(row: 0, column: 0), Position(row: 0, column: 1)])
        sut.reset()
        sut.calculate(with: [Position(row: 0, column: 0)])
        #expect(sut.positions.isEmpty)
    }
}
