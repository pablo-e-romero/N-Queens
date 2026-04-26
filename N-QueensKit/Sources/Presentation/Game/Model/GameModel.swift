//
//  GameModel.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import Foundation
import Domain
import Observation

@Observable
final class GameModel {
    var placedQueensCount: Int {
        placedQueens.count
    }
    
    var hasConflicts: Bool {
        !conflictingPositions.isEmpty
    }
    
    let boardSize: Int
    private(set) var board: [[Cell]]!
    private(set) var timeElapsedFormatted: String = ""

    private var placedQueens: Set<Position> = []
    private var conflictingPositions: Set<Position> = []
    private var timeManager: TimeManagerProtocol
    private let exitGame: () -> Void
    
    init(
        boardSize: Int = 4,
        timeManager: TimeManagerProtocol,
        exitGame: @escaping () -> Void
    ) {
        self.boardSize = boardSize
        self.timeManager = timeManager
        self.exitGame = exitGame
        self.board = makeBoard(size: boardSize)
        
        timeManager.onTimeUpdate = { [weak self] timeElapsedFormatted in
            self?.timeElapsedFormatted = timeElapsedFormatted
        }
    }
    
    func onAppear() {
        timeManager.startTimer()
    }
    
    func onCellTap(_ position: Position) {
        let containsPosition = placedQueens.contains(position)
        
        guard containsPosition || placedQueensCount < boardSize else { return }
        
        if containsPosition {
            placedQueens.remove(position)
        } else {
            placedQueens.insert(position)
        }
        
        conflictingPositions = calculateConflictingPositions(
            Array(placedQueens)
        )
        
        board = makeBoard(
            size: boardSize,
            placedQueens: placedQueens,
            conflictingPositions: conflictingPositions
        )

//        if WinChecker.hasWon(state.boardState) {
//            let finalTime = timer.stop()
//            state.phase = .won(elapsedTime: finalTime)
//            soundManager.play(.victory)
//            saveBestTimeIfNeeded(finalTime)
//        }
    }
    
    func onRestart() {
        timeManager.stopTimer()
        board = makeBoard(size: boardSize)
        placedQueens = []
        conflictingPositions = []
        timeManager.startTimer()
    }
    
    func onExit() {
        exitGame()
    }
}

private extension GameModel {
    func makeBoard(
        size: Int,
        placedQueens: Set<Position> = [],
        conflictingPositions: Set<Position> = []
    ) -> [[Cell]] {
        var cells = [[Cell]]()
        
        for row in 0..<boardSize {
            var rowCells = [Cell]()

            for column in 0..<boardSize {
                let position = Position(row: row, column: column)
                rowCells.append(
                    Cell(
                        row: row,
                        column: column,
                        hasQueen: placedQueens.contains(position),
                        isConflicting: conflictingPositions.contains(position)
                    )
                )
            }
            cells.append(rowCells)
        }
        
        return cells
    }
    
    func calculateConflictingPositions(
        _ placedQueens: [Position]
    ) -> Set<Position> {
        func areConflicting(
            _ first: Position,
            _ second: Position
        ) -> Bool {
            first.row == second.row ||
            first.column == second.column ||
            abs(first.row - second.row) == abs(first.column - second.column)
        }

        var conflictingPositions = Set<Position>()

        for i in 0..<placedQueens.count {
            for j in (i + 1)..<placedQueens.count {
                let first = placedQueens[i]
                let second = placedQueens[j]
                if areConflicting(first, second) {
                    conflictingPositions.insert(first)
                    conflictingPositions.insert(second)
                }
            }
        }

        return conflictingPositions
    }
}
