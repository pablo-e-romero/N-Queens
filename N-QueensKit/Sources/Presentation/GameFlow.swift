//
//  GameFlow.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI
import Infrastructure

enum Route: Hashable {
    case game(Int)
    case bestTimes
}

public struct GameFlow: View {
    public typealias Dependencies = GameViewModelFactory & BestTimesViewModelFactory
    let dependencies: Dependencies

    @State var route: [Route] = []
    @State var won: GameViewModelActions.GameInfo?
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.route = route
    }

    public var body: some View {
        NavigationStack(path: $route) {
            GameSetupView(
                viewModel: GameSetupViewModel(
                    startGame: { boardSize in
                        route.append(.game(boardSize))
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
                            actions: GameViewModelActions(
                                exitGame: { self.route.removeAll() },
                                wonGame: { gameInto in
                                    self.won = gameInto
                                }
                            )
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
        .sheet(
            item: $won,
            onDismiss: { route.removeAll() }) { gameInfo in
            WonView(gameInfo: gameInfo) {
                won = nil
                route.removeAll()
            }
        }
    }
}
