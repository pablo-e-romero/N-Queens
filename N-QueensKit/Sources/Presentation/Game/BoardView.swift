//
//  BoardView.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI

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

#Preview {
    BoardView(
        cells: [
            [
                .init(
                    hasQueen: true,
                    isConflicting: true,
                    isLightSquare: true
                ),
                .init(
                    hasQueen: false,
                    isConflicting: true,
                    isLightSquare: false
                ),
                .init(
                    hasQueen: true,
                    isConflicting: true,
                    isLightSquare: true
                )
            ],
            [
                .init(
                    hasQueen: false,
                    isConflicting: false,
                    isLightSquare: false
                ),
                .init(
                    hasQueen: false,
                    isConflicting: false,
                    isLightSquare: true
                ),
                .init(
                    hasQueen: false,
                    isConflicting: false,
                    isLightSquare: false
                )
            ],
            [
                .init(
                    hasQueen: false,
                    isConflicting: false,
                    isLightSquare: true
                ),
                .init(
                    hasQueen: true,
                    isConflicting: false,
                    isLightSquare: false
                ),
                .init(
                    hasQueen: false,
                    isConflicting: false,
                    isLightSquare: true
                )
            ]
        ],
        onCellTap: { _ in }
    )
}
