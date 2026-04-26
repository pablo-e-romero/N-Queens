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
    let wonGamesRepository: WonGamesRepositoryProtocol

    init(
        timeManager: TimeManagerProtocol,
        wonGamesRepository: WonGamesRepositoryProtocol
    ) {
        self.timeManager = timeManager
        self.wonGamesRepository = wonGamesRepository
    }
}

extension DependenciesContainer {
    static var live: DependenciesContainer {
        return .init(
            timeManager: TimeManager(),
            wonGamesRepository: WonGamesRepository()
        )
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
            wonGamesRepository: wonGamesRepository,
            actions: actions
        )
    }
}

extension DependenciesContainer: BestTimesViewModelFactory {
    func makeBestTimesViewModel() -> BestTimesViewModel {
        BestTimesViewModel(wonGamesRepository: wonGamesRepository)
    }
}
