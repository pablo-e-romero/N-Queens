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
            QueensRemainingView(
                placed: model.placedQueensCount,
                total: model.boardSize
            )
            
            BoardView(
                cells: model.board,
                onCellTap: model.onCellTap
            )
            .padding(.horizontal)
            
            if model.hasConflicts {
                Text("Some queens are threatening each other!")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .transition(.opacity)
            }
            
            Spacer()
        }
        .padding(.top)
        .animation(.easeInOut(duration: 0.3), value: model.hasConflicts)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    model.onExit()
                }
            }
            
            ToolbarItem(placement: .title) {
                Text(model.timeElapsedFormatted)
                    .font(.title2.monospacedDigit())
                    .accessibilityIdentifier("timerLabel")
            }
            
            ToolbarItem(placement: .destructiveAction) {
                Button("Restart") {
                    model.onRestart()
                }
            }
        }
        .onAppear(perform: model.onAppear)
    }
}

struct QueensRemainingView: View {
    let placed: Int
    let total: Int
    
    var body: some View {
        Text("\(placed) / \(total) Queens")
            .font(.headline)
            .monospacedDigit()
            .accessibilityIdentifier("queensRemaining")
    }
}
