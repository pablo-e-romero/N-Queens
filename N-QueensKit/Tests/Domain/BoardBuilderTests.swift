//
//  BoardBuilderTests.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Testing
@testable import Domain

@MainActor
struct BoardBuilderTests {
    let sut = BoardBuilder()

    @Test func boardHasCorrectDimensions() {
        let board = sut.make(from: GameState(boardSize: 4))
        #expect(board.count == 4)
        #expect(board.allSatisfy { $0.count == 4 })
    }

    @Test func emptyBoardHasNoQueens() {
        let board = sut.make(from: GameState(boardSize: 4))
        #expect(board.allSatisfy { $0.allSatisfy { !$0.hasQueen } })
    }

    @Test func emptyBoardHasNoConflicts() {
        let board = sut.make(from: GameState(boardSize: 4))
        #expect(board.allSatisfy { $0.allSatisfy { !$0.isConflicting } })
    }

    @Test func queenIsReflectedInCell() {
        let queen = Position(row: 1, column: 2)
        let board = sut.make(from: GameState(boardSize: 4, placedQueens: [queen]))
        #expect(board[1][2].hasQueen)
        #expect(!board[0][0].hasQueen)
    }

    @Test func conflictIsReflectedInCell() {
        let conflicting = Position(row: 0, column: 3)
        let board = sut.make(from: GameState(boardSize: 4, conflictingPositions: [conflicting]))
        #expect(board[0][3].isConflicting)
        #expect(!board[0][0].isConflicting)
    }

    @Test func lightSquarePatternIsCorrect() {
        let board = sut.make(from: GameState(boardSize: 4))
        for row in 0..<4 {
            for col in 0..<4 {
                #expect(board[row][col].isLightSquare == ((row + col) % 2 == 0))
            }
        }
    }

    @Test func cellPositionsMatchCoordinates() {
        let board = sut.make(from: GameState(boardSize: 3))
        for row in 0..<3 {
            for col in 0..<3 {
                #expect(board[row][col].position == Position(row: row, column: col))
            }
        }
    }

    @Test func accessibilityIdentifierFormat() {
        let board = sut.make(from: GameState(boardSize: 4))
        #expect(board[2][3].accessibilityIdentifier == "cell_2_3")
    }
}
