//
//  BestTimesView.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import SwiftUI

struct BestTimesView: View {
    @State var viewModel: BestTimesViewModel
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .tint(Color.AppTheme.tint)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .error:
                Text("There was an error fetching data")
            case .empty:
                EmptyState()
            case let .loaded(games):
                GamesList(games: games)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.AppTheme.background)
        .navigationTitle("Best Times")
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.onTask() }
    }
}

private struct EmptyState: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("♛")
                .font(.system(size: 56))
            Text("No games yet")
                .font(.title3)
                .foregroundStyle(Color.AppTheme.secondary)
        }
    }
}

private struct GamesList: View {
    let games: [BestTimesViewModel.WonGameInfo]
    
    var body: some View {
        List {
            ForEach(Array(games.enumerated()), id: \.offset) { index, game in
                BestTimesRow(
                    rank: index + 1,
                    boardSize: game.boardSize,
                    time: game.formattedTime
                )
                .listRowBackground(Color.clear)
                .listRowSeparatorTint(Color.AppTheme.secondary.opacity(0.2))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

private struct BestTimesRow: View {
    let rank: Int
    let boardSize: String
    let time: String

    var body: some View {
        HStack(spacing: 12) {
            Text("\(rank)")
                .font(.headline.monospacedDigit())
                .foregroundStyle(Color.AppTheme.secondary)
                .frame(width: 28, alignment: .center)

            Image(systemName: "squareshape.split.2x2")
                .foregroundStyle(Color.AppTheme.tint)

            Text("\(boardSize) × \(boardSize)")
                .font(.headline)
                .foregroundStyle(Color.AppTheme.primary)

            Spacer()

            HStack(spacing: 6) {
                Image(systemName: "clock.fill")
                    .font(.caption)
                Text(time)
                    .font(.headline.monospacedDigit())
            }
            .foregroundStyle(Color.AppTheme.primary)
        }
        .padding(.vertical, 4)
    }
}
