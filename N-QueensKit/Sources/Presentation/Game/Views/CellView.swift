//
//  CellView.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI
import Domain

struct CellView: View {
    let cell: Cell
    let onTap: (Position) -> Void

    var body: some View {
        Button(action: { onTap(cell.position) }) {
            ZStack {
                Rectangle()
                    .fill(squareColor)

                if cell.isConflicting {
                    Rectangle()
                        .fill(Color.AppTheme.conflictBackground)
                        .transition(.opacity)
                }

                if cell.hasQueen {
                    Image("queen", bundle: .module)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(4)
                        .frame(maxWidth: 66)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .buttonStyle(.plain)
        .aspectRatio(1, contentMode: .fit)
        .accessibilityIdentifier(cell.accessibilityIdentifier)
        .accessibilityLabel(cell.accessibilityLabel)
        .animation(.spring(duration: 0.15), value: cell.hasQueen)
        .animation(.easeInOut(duration: 0.15), value: cell.isConflicting)
    }

    private var squareColor: Color {
        cell.isLightSquare ?
        .AppTheme.lightCellBackground :
        .AppTheme.darkCellBackground
    }

    private var queenColor: Color {
        if cell.isConflicting { return .AppTheme.conflictForeground }
        return .AppTheme.cellForeground
    }
}

#Preview("Light square") {
    CellView(
        cell: Cell(
            position: Position(row: 0, column: 0),
            hasQueen: false,
            isConflicting: false
        ),
        onTap: { _ in }
    )
}

#Preview("Dark square") {
    CellView(
        cell: Cell(
            position: Position(row: 0, column: 1),
            hasQueen: false,
            isConflicting: false
        ),
        onTap: { _ in }
    )
}

#Preview("Light square with queen") {
    CellView(
        cell: Cell(
            position: Position(row: 0, column: 0),
            hasQueen: true,
            isConflicting: false
        ),
        onTap: { _ in }
    )
}

#Preview("Dark square with queen") {
    CellView(
        cell: Cell(
            position: Position(row: 0, column: 1),
            hasQueen: true,
            isConflicting: false
        ),
        onTap: { _ in }
    )
}

#Preview("Light square with conflict") {
    CellView(
        cell: Cell(
            position: Position(row: 0, column: 0),
            hasQueen: true,
            isConflicting: true
        ),
        onTap: { _ in }
    )
}

#Preview("Dark square with conflict") {
    CellView(
        cell: Cell(
            position: Position(row: 0, column: 1),
            hasQueen: true,
            isConflicting: true
        ),
        onTap: { _ in }
    )
}
