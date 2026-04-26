//
//  DependenciesContainer.swift
//  N-Queens
//
//  Created by Pablo Romero on 26/04/2026.
//

import Foundation
import Infrastructure
import Domain
import Presentation

final class DependenciesContainer {
    let timeManager: TimeManagerProtocol

    init(timeManager: TimeManagerProtocol) {
        self.timeManager = timeManager
    }
}

extension DependenciesContainer {
    static var live: DependenciesContainer {
        return .init(timeManager: TimeManager())
    }
}

extension DependenciesContainer: GameViewModelFactory {
    func makeGameViewModel(
        boardSize: Int,
        actions: GameViewModelActions,
    ) -> GameViewModel {
        GameViewModel(
            gameModel: GameModel(boardSize: boardSize),
            timeManager: timeManager,
            actions: actions
        )
    }
}
