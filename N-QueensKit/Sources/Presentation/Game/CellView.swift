//
//  CellView.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI


struct CellView: View {
    let cell: Cell
    let onTap: (Position) -> Void

    var body: some View {
        Button(action: { onTap(cell.position) }) {
            ZStack {
                Rectangle()
                    .fill(backgroundColor)

                if cell.hasQueen {
                    Text("\u{265B}")
                        .font(.system(size: 200))
                        .minimumScaleFactor(0.01)
                        .foregroundStyle(cell.isConflicting ? .red : .primary)
                        .padding(2)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .buttonStyle(.plain)
        .aspectRatio(1, contentMode: .fit)
        .accessibilityIdentifier(cell.accessibilityIdentifier)
        .accessibilityLabel(cell.accessibilityLabel)
        .animation(.spring(duration: 0.3), value: cell.hasQueen)
        .animation(.easeInOut(duration: 0.2), value: cell.isConflicting)
    }

    private var backgroundColor: Color {
        guard cell.isConflicting else  {
            return cell.isLightSquare ? Color(.systemGray5) : Color(.systemGray3)
        }
        
        return .red.opacity(0.3)
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
