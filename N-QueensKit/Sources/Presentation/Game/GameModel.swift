//
//  GameModel.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import Foundation
import Observation

@Observable
final class GameModel {
    var timeElapsedFormatted: String {
        let totalSeconds = Int(timeElapsed)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        let tenths = Int((timeElapsed - Double(totalSeconds)) * 10)
        return String(format: "%02d:%02d.%d", minutes, seconds, tenths)
    }
    
    var placedQueensCount: Int {
        placedQueens.count
    }
    
    var hasConflicts: Bool {
        !conflictingPositions.isEmpty
    }
    
    let boardSize: Int
    private(set) var cells: [[Cell]]
    private var placedQueens: Set<Position> = []
    private var conflictingPositions: Set<Position> = []
    
    private var timeElapsed: TimeInterval = 0
    private var timerTask: Task<Void, Never>?
    private let exitGame: () -> Void
    
    init(
        boardSize: Int = 4,
        exitGame: @escaping () -> Void
    ) {
        self.boardSize = boardSize
        self.exitGame = exitGame
        self.cells = Self.makeCells(boardSize: boardSize)
    }
    
    func onAppear() {
        startTimer()
    }
    
    func onCellTap(_ position: Position) {
        if placedQueens.contains(position) {
            placedQueens.remove(position)
        } else if placedQueensCount < boardSize {
            placedQueens.insert(position)
        }
        
        conflictingPositions = calculateConflicts(Array(placedQueens))
        cells = Self.makeCells(
            boardSize: boardSize,
            placedQueens: placedQueens,
            conflictingPositions: conflictingPositions
        )
        
//        let feedback = UIImpactFeedbackGenerator(style: hadQueen ? .light : .medium)
//        feedback.impactOccurred()
        
//        soundManager.play(hadQueen ? .remove : .place)
        
//        if WinChecker.hasWon(state.boardState) {
//            let finalTime = timer.stop()
//            state.phase = .won(elapsedTime: finalTime)
//            soundManager.play(.victory)
//            saveBestTimeIfNeeded(finalTime)
//        }
    }
    
    func onRestart() {
        stopTimer()
        timeElapsed = 0
        cells = Self.makeCells(boardSize: boardSize)
        placedQueens = []
        conflictingPositions = []
        startTimer()
    }
    
    func onExit() {
        exitGame()
    }
}

private extension GameModel {
    func startTimer() {
        guard timerTask == nil else { return }
        timeElapsed = 0
        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(100))
                guard let self else { break }
                self.timeElapsed += 0.1
            }
        }
    }
    
    func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }
    
    static func makeCells(
        boardSize: Int,
        placedQueens: Set<Position> = [],
        conflictingPositions: Set<Position> = []
    ) -> [[Cell]] {
        var cells = [[Cell]]()
        
        for row in (0..<boardSize) {
            var rowCells = [Cell]()
            for column in (0..<boardSize) {
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
    
    func calculateConflicts(_ placedQueens: [Position]) -> Set<Position> {
        func areConflicting(_ a: Position, _ b: Position) -> Bool {
            if a.row == b.row { return true }
            if a.column == b.column { return true }
            if abs(a.row - b.row) == abs(a.column - b.column) { return true }
            return false
        }

        var conflicting = Set<Position>()

        for i in 0..<placedQueens.count {
            for j in (i + 1)..<placedQueens.count {
                let a = placedQueens[i]
                let b = placedQueens[j]
                if areConflicting(a, b) {
                    conflicting.insert(a)
                    conflicting.insert(b)
                }
            }
        }

        return conflicting
    }
}
