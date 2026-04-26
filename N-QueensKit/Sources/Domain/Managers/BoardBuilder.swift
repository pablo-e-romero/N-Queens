//
//  BoardBuilder.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

public struct BoardBuilder {
    public init() {}
    
    public func make(
        from gameState: GameState
    ) -> [[Cell]] {
        var cells = [[Cell]]()
        
        for row in 0..<gameState.boardSize {
            var rowCells = [Cell]()

            for column in 0..<gameState.boardSize {
                let position = Position(row: row, column: column)
                rowCells.append(
                    Cell(
                        row: row,
                        column: column,
                        hasQueen: gameState.placedQueens.contains(position),
                        isConflicting: gameState.conflictingPositions.contains(position)
                    )
                )
            }
            cells.append(rowCells)
        }
        
        return cells
    }
}
