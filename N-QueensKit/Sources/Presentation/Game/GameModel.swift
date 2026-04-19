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
    private(set) var placedQueens: Int = 0
    private(set) var hasConflicts: Bool = false
    private(set) var cells: [[CellModel]]
    private var timeElapsed: TimeInterval = 0
    private var timerTask: Task<Void, Never>?
    private let exitGame: () -> Void
    
    init(
        boardSize: Int = 4,
        exitGame: @escaping () -> Void
    ) {
        self.exitGame = exitGame
        self.cells = Self.makeCells(boardSize: boardSize)
    }
    
    func onAppear() {
        startTimer()
    }
    
    func onCellTap(row: Int, column: Int) {
        
    }
    
    func onRestart() {
        resetTimer()
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

    func resetTimer() {
        stopTimer()
        timeElapsed = 0
    }
    
    static func makeCells(boardSize: Int) -> [[CellModel]] {
        var cells = [[CellModel]]()
        
        for row in (0..<boardSize) {
            var rowCells = [CellModel]()
            for column in (0..<boardSize) {
                rowCells.append(CellModel(row: row, column: column))
            }
            cells.append(rowCells)
        }
        
        return cells
    }
}
