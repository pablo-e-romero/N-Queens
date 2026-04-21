//
//  GameView.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI

struct GameView: View {
    @State var model: GameModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                QueensRemainingView(
                    placed: model.placedQueensCount,
                    total: model.boardSize
                )
                
                Spacer()
                
                TimeElapsedView(
                    timeElapsedFormatted: model.timeElapsedFormatted
                )
            }
            .padding(.horizontal)
            
            BoardView(
                cells: model.board,
                onCellTap: model.onCellTap
            )
            .padding(.horizontal)
            
            if model.hasConflicts {
                ConflictsView()
            }
            
            Spacer()
        }
        .padding(.top)
        .animation(.easeInOut(duration: 0.3), value: model.hasConflicts)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: model.onExit,
                    label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.AppTheme.secondary)
                    }
                )
            }
            
            ToolbarItem(placement: .title) {
                Text("N-Queens · \(model.boardSize)×\(model.boardSize)")
                    .font(.title2)
                    .foregroundStyle(Color.AppTheme.primary)
            }
            
            ToolbarItem(placement: .destructiveAction) {
                Button(
                    action: model.onRestart,
                    label: {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundStyle(Color.AppTheme.secondary)
                    }
                )
            }
        }
        .background(Color.AppTheme.background)
        .onAppear(perform: model.onAppear)
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
