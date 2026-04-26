//
//  GameView.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI
import Domain

struct GameView: View {
    @State var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                QueensRemainingView(
                    placed: viewModel.gameState.placedQueensCount,
                    total: viewModel.gameState.boardSize
                )
                
                Spacer()
                
                TimeElapsedView(
                    timeElapsedFormatted: viewModel.timeElapsedFormatted
                )
            }
            .padding(.horizontal)
            
            BoardView(
                cells: viewModel.board,
                onCellTap: viewModel.onCellTap
            )
            .padding(.horizontal)
            
            if viewModel.gameState.hasConflicts {
                ConflictsView()
            }
            
            if viewModel.gameState.won {
                WonView(onPlayAgain: viewModel.onExit)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            Spacer()
        }
        .padding(.top)
        .animation(
            .easeInOut(duration: 0.3),
            value: viewModel.gameState.hasConflicts
        )
        .animation(
            .spring(duration: 0.5, bounce: 0.2),
            value: viewModel.gameState.won
        )
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: viewModel.onExit,
                    label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.AppTheme.secondary)
                    }
                )
            }
            
            ToolbarItem(placement: .title) {
                Text("N-Queens · \(viewModel.gameState.boardSize)×\(viewModel.gameState.boardSize)")
                    .font(.title2)
                    .foregroundStyle(Color.AppTheme.primary)
            }
            
            ToolbarItem(placement: .destructiveAction) {
                Button(
                    action: viewModel.onReset,
                    label: {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundStyle(Color.AppTheme.secondary)
                    }
                )
            }
        }
        .background(Color.AppTheme.background)
        .onAppear(perform: viewModel.onAppear)
    }
}

struct ConflictsView: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.caption)
            Text("Queens in conflict")
        }
        .font(.title2)
        .foregroundStyle(Color.AppTheme.conflictForeground)
    }
}

struct TimeElapsedView: View {
    let timeElapsedFormatted: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "clock.fill")
                .font(.caption)
            Text(timeElapsedFormatted)
                .font(.title3.monospacedDigit().bold())
        }
        .foregroundStyle(Color.AppTheme.primary)
        .padding(.horizontal, 12)
        .frame(height: 33)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.AppTheme.secondaryBackground)
        )
        .accessibilityIdentifier("timeElapsed")
    }
}

struct QueensRemainingView: View {
    let placed: Int
    let total: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Text("♛")
                .font(.title2.bold())
            Text("\(placed) / \(total)")
                .font(.title3.monospacedDigit().bold())
        }
        .foregroundStyle(Color.AppTheme.primary)
        .padding(.horizontal, 12)
        .frame(height: 33)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.AppTheme.secondaryBackground)
        )
        .accessibilityIdentifier("queensRemaining")
    }
}

struct WonView: View {
    let onPlayAgain: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("♛")
                .font(.system(size: 64))
                .padding(.top, 8)

            Text("You Won!")
                .font(.largeTitle.bold())
                .foregroundStyle(Color.AppTheme.primary)

            Button("Play Again", action: onPlayAgain)
                .buttonStyle(.greenPrimary)
                .padding(.horizontal, .AppTheme.padding)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.AppTheme.background)
    }
}
