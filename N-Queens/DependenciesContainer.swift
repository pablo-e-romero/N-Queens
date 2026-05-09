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
    let timeCounter: TimeCounterProtocol
    let wonGamesRepository: WonGamesRepositoryProtocol

    init(
        timeCounter: TimeCounterProtocol,
        wonGamesRepository: WonGamesRepositoryProtocol
    ) {
        self.timeCounter = timeCounter
        self.wonGamesRepository = wonGamesRepository
    }
}

extension DependenciesContainer {
    static var live: DependenciesContainer {
        return .init(
            timeCounter: TimeCounter(),
            wonGamesRepository: WonGamesRepository()
        )
    }
}

extension DependenciesContainer: GameViewModelFactory {
    func makeGameViewModel(
        boardSize: Int,
        exitGame: @escaping () -> Void
    ) -> GameViewModel {
        GameViewModel(
            gameModel: GameModel(boardSize: boardSize),
            timeCounter: timeCounter,
            wonGamesRepository: wonGamesRepository,
            exitGame: exitGame
        )
    }
}

extension DependenciesContainer: BestTimesViewModelFactory {
    func makeBestTimesViewModel() -> BestTimesViewModel {
        BestTimesViewModel(wonGamesRepository: wonGamesRepository)
    }
}
