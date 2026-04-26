//
//  GameFlow.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI
import Infrastructure

public enum Route: Hashable {
    case game(Int)
}

public struct GameFlow: View {
    public typealias Dependencies = GameViewModelFactory
    let dependencies: Dependencies

    @SwiftUI.State var route: [Route] = []

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.route = route
    }

    public var body: some View {
        NavigationStack(path: $route) {
            SetuptGameView(
                viewModel: SetupGameViewModel(
                    startGame: { boardSize in
                        route.append(.game(boardSize))
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
                                wonGame: { }
                            )
                        )
                    )
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
