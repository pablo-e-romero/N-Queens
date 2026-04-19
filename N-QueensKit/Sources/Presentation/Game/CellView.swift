//
//  CellView.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI


struct CellView: View {
    let model: CellModel
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Rectangle()
                    .fill(backgroundColor)

                if model.hasQueen {
                    Text("\u{265B}")
                        .font(.system(size: 200))
                        .minimumScaleFactor(0.01)
                        .foregroundStyle(model.isConflicting ? .red : .primary)
                        .padding(2)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .buttonStyle(.plain)
        .aspectRatio(1, contentMode: .fit)
        .accessibilityIdentifier(model.accessibilityIdentifier)
        .accessibilityLabel(model.accessibilityLabel)
        .animation(.spring(duration: 0.3), value: model.hasQueen)
        .animation(.easeInOut(duration: 0.2), value: model.isConflicting)
    }

    private var backgroundColor: Color {
        guard model.isConflicting else  {
            return model.isLightSquare ? Color(.systemGray5) : Color(.systemGray3)
        }
        
        return .red.opacity(0.3)
    }
}

#Preview("Dark square") {
    CellView(
        model: .init(
            row: 0,
            column: 0,
            hasQueen: false,
            isConflicting: false,
            isLightSquare: false,
        ),
        onTap: {}
    )
}

#Preview("Light square") {
    CellView(
        model: .init(
            row: 0,
            column: 0,
            hasQueen: false,
            isConflicting: false,
            isLightSquare: true,
        ),
        onTap: {}
    )
}

#Preview("Dark square with queen") {
    CellView(
        model: .init(
            row: 0,
            column: 0,
            hasQueen: true,
            isConflicting: false,
            isLightSquare: false
        ),
        onTap: {}
    )
}

#Preview("Light square with queen") {
    CellView(
        model: .init(
            row: 0,
            column: 0,
            hasQueen: true,
            isConflicting: false,
            isLightSquare: true
        ),
        onTap: {}
    )
}

#Preview("Dark square with conflict") {
    CellView(
        model: .init(
            row: 0,
            column: 0,
            hasQueen: true,
            isConflicting: true,
            isLightSquare: false
        ),
        onTap: {}
    )
}

#Preview("Light square with conflict") {
    CellView(
        model: .init(
            row: 0,
            column: 0,
            hasQueen: true,
            isConflicting: true,
            isLightSquare: true
        ),
        onTap: {}
    )
}
