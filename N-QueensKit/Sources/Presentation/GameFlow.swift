//
//  GameFlow.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI

enum Route: Hashable {
    case game(boardSize: Int)
    case bestTimes
}

public struct GameFlow: View {
    public typealias Dependencies = GameViewModelFactory & BestTimesViewModelFactory
    let dependencies: Dependencies

    @State var route: [Route] = []
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.route = route
    }

    public var body: some View {
        NavigationStack(path: $route) {
            GameSetupView(
                viewModel: GameSetupViewModel(
                    startGame: { boardSize in
                        route.append(.game(boardSize: boardSize))
                    },
                    showBestTimes: {
                        route.append(.bestTimes)
                    }
                )
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .game(boardSize):
                    GameView(
                        viewModel: dependencies.makeGameViewModel(
                            boardSize: boardSize,
                            exitGame: { self.route.removeAll() }
                        )
                    )
                case .bestTimes:
                    BestTimesView(
                        viewModel: dependencies.makeBestTimesViewModel()
                    )
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
