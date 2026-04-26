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
                        .padding(4)
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

#Preview("Dark square") {
    CellView(
        cell: .init(
            hasQueen: false,
            isConflicting: false,
            isLightSquare: false,
        ),
        onTap: { _ in }
    )
}

#Preview("Light square") {
    CellView(
        cell: .init(
            hasQueen: false,
            isConflicting: false,
            isLightSquare: true,
        ),
        onTap: { _ in }
    )
}

#Preview("Dark square with queen") {
    CellView(
        cell: .init(
            hasQueen: true,
            isConflicting: false,
            isLightSquare: false
        ),
        onTap: { _ in }
    )
}

#Preview("Light square with queen") {
    CellView(
        cell: .init(
            hasQueen: true,
            isConflicting: false,
            isLightSquare: true
        ),
        onTap: { _ in }
    )
}

#Preview("Dark square with conflict") {
    CellView(
        cell: .init(
            hasQueen: true,
            isConflicting: true,
            isLightSquare: false
        ),
        onTap: { _ in }
    )
}

#Preview("Light square with conflict") {
    CellView(
        cell: .init(
            hasQueen: true,
            isConflicting: true,
            isLightSquare: true
        ),
        onTap: { _ in }
    )
}
