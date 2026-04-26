//
//  BoardBuilder.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

@MainActor
public final class BoardBuilder {
    public init() {}
    
    func make(
        size: Int,
        placedQueens: Set<Position> = [],
        conflictingPositions: Set<Position> = []
    ) -> [[Cell]] {
        var cells = [[Cell]]()
        
        for row in 0..<size {
            var rowCells = [Cell]()

            for column in 0..<size {
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
}
