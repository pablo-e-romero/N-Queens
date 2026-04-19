//
//  BoardView.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI

struct BoardView: View {
    let cells: [[CellModel]]
    let onCellTap: (_ row: Int, _ column: Int) -> Void
    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<cells.count, id: \.self) { row in
                GridRow {
                    ForEach(0..<cells[row].count, id: \.self) { column in
                        CellView(
                            model: cells[row][column],
                            onTap: { onCellTap(row, column) }
                        )
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.secondary, lineWidth: 2)
        )
        .accessibilityIdentifier("chessboard")
    }
}

#Preview {
    BoardView(
        cells: [
            [
                .init(
                    row: 0,
                    column: 0,
                    hasQueen: true,
                    isConflicting: true,
                    isLightSquare: true
                ),
                .init(
                    row: 0,
                    column: 1,
                    hasQueen: false,
                    isConflicting: true,
                    isLightSquare: false
                ),
                .init(
                    row: 0,
                    column: 2,
                    hasQueen: true,
                    isConflicting: true,
                    isLightSquare: true
                )
            ],
            [
                .init(
                    row: 1,
                    column: 0,
                    hasQueen: false,
                    isConflicting: false,
                    isLightSquare: false
                ),
                .init(
                    row: 1,
                    column: 1,
                    hasQueen: false,
                    isConflicting: false,
                    isLightSquare: true
                ),
                .init(
                    row: 1,
                    column: 2,
                    hasQueen: false,
                    isConflicting: false,
                    isLightSquare: false
                )
            ],
            [
                .init(
                    row: 2,
                    column: 0,
                    hasQueen: false,
                    isConflicting: false,
                    isLightSquare: true
                ),
                .init(
                    row: 2,
                    column: 1,
                    hasQueen: true,
                    isConflicting: false,
                    isLightSquare: false
                ),
                .init(
                    row: 2,
                    column: 2,
                    hasQueen: false,
                    isConflicting: false,
                    isLightSquare: true
                )
            ]
        ],
        onCellTap: { _, _ in }
    )
}
