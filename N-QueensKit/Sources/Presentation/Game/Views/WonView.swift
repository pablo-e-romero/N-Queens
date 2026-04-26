//
//  WonView.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import SwiftUI

struct WonView: View {
    let gameInfo: GameViewModelActions.GameInfo
    let onPlayAgain: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("♛")
                .font(.system(size: 64))
                .padding(.top, 8)

            Text("You Won!")
                .font(.largeTitle.bold())
                .foregroundStyle(Color.AppTheme.primary)

            VStack(spacing: 12) {
                StatRow(
                    icon: "squareshape.split.2x2",
                    label: "Board",
                    value: "\(gameInfo.gameState.boardSize) × \(gameInfo.gameState.boardSize)"
                )
                StatRow(
                    icon: "clock.fill",
                    label: "Time",
                    value: gameInfo.timeElapsedFormatted
                )
            }
            .padding(.horizontal, .AppTheme.padding)

            Button("Play Again", action: onPlayAgain)
                .buttonStyle(.greenPrimary)
                .padding(.horizontal, .AppTheme.padding)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.AppTheme.background)
    }
}

private struct StatRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(Color.AppTheme.tint)
                .font(.title3)
                .frame(width: 28)

            Text(label)
                .font(.headline)
                .foregroundStyle(Color.AppTheme.secondary)

            Spacer()

            Text(value)
                .font(.headline.monospacedDigit())
                .foregroundStyle(Color.AppTheme.primary)
        }
        .padding(.AppTheme.padding)
        .background(Color.AppTheme.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: .AppTheme.cornerRadius))
    }
}
