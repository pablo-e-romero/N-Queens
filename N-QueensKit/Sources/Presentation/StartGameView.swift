//
//  StartGameView.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI

struct StartGameView: View {
    @Bindable var model: StartGameModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text("N-Queens")
                .font(.largeTitle.bold())
            
            Text("Place N queens on an N\u{00D7}N board so no two threaten each other")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            VStack(spacing: 16) {
                Text("Board Size")
                    .font(.headline)

                Stepper(
                    "\(model.boardSize) \u{00D7} \(model.boardSize)",
                    value: $model.boardSize,
                    in: 4...20
                )
                .font(.title2.monospacedDigit())
                .padding(.horizontal, 40)
            }

            Spacer()
            
            Button {
                model.onStartGame()
            } label: {
                Text("Start Game")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 40)
            .accessibilityIdentifier("startButton")
        }
    }
}
