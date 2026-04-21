//
//  SetuptGameView.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI

struct SetuptGameView: View {
    @Bindable var model: SetupGameModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("♛")
                .font(.system(size: 80))
                .padding(.top, 20)
                .padding(.bottom, 48)
            
            BoardSizeMenu(boardSize: $model.boardSize)
                .padding(16)
            
            Button("Start Game") {
                model.onStartGame()
            }
            .buttonStyle(.greenPrimary)
            .padding(.horizontal, 16)
            .accessibilityIdentifier("startButton")
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.AppTheme.background)
        .navigationTitle("N-Queens")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct BoardSizeMenu: View {
    @Binding var boardSize: Int

    var body: some View {
        Menu {
            Picker("Board Size", selection: $boardSize) {
                ForEach(Array(4...20), id: \.self) { size in
                    Text("\(size) × \(size)").tag(size)
                }
            }
        } label: {
            HStack {
                Image(systemName: "squareshape.split.2x2")
                    .foregroundStyle(Color.AppTheme.tint)
                    .font(.title3)
                
                Text("\(boardSize) × \(boardSize)")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .monospacedDigit()
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundStyle(Color.AppTheme.tint)
                    .font(.subheadline)
            }
            .padding(16)
            .background(Color.AppTheme.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
