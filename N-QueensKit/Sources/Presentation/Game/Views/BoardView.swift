//
//  BoardView.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI
import Domain

struct BoardView: View {
    let cells: [[Cell]]
    let onCellTap: (_ position: Position) -> Void
    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<cells.count, id: \.self) { row in
                GridRow {
                    ForEach(0..<cells[row].count, id: \.self) { column in
                        CellView(
                            cell: cells[row][column],
                            onTap: onCellTap
                        )
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: .AppTheme.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: .AppTheme.cornerRadius)
                .stroke(.secondary, lineWidth: 2)
                .foregroundStyle(Color.AppTheme.cellForeground)
        )
        .accessibilityIdentifier("chessboard")
    }
}

#Preview("4x4") {
    BoardView(
        cells: BoardBuilder().make(
            from: GameState(
                boardSize: 4,
                placedQueens: [
                    Position(row: 0, column: 0),
                    Position(row: 0, column: 3),
                ],
                conflictingPositions: [
                    Position(row: 0, column: 0),
                    Position(row: 0, column: 3),
                ]
            )
        ),
        onCellTap: { _ in }
    )
}

#Preview("20x20") {
    BoardView(
        cells: BoardBuilder().make(
            from: GameState(
                boardSize: 20,
                placedQueens: [
                    Position(row: 0, column: 0),
                    Position(row: 0, column: 19),
                ],
                conflictingPositions: [
                    Position(row: 0, column: 0),
                    Position(row: 0, column: 19),
                ]
            )
        ),
        onCellTap: { _ in }
    )
}
