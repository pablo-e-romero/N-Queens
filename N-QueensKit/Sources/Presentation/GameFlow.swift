//
//  GameFlow.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI

public enum Route: Hashable {
    case game(Int)
}

public struct GameFlow: View {
    @SwiftUI.State var route: [Route] = []

    public init() {}

    public var body: some View {
        NavigationStack(path: $route) {
            StartGameView(
                model: StartGameModel(startGame: { boardSize in
                    route.append(.game(boardSize))
                })
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .game(boardSize):
                    GameView(
                        model: GameModel(
                            boardSize: boardSize,
                            restartGame: {}
                        )
                    )
                }
            }
        }
    }
}
