//
//  GameViewModel.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Foundation
import Domain
import Observation

public protocol GameViewModelFactory {
    func makeGameViewModel(
        boardSize: Int,
        exitGame: @escaping () -> Void
    ) -> GameViewModel
}

@Observable
public final class GameViewModel {
    private(set) var gameState: GameState
    private(set) var board: [[Cell]]
    private(set) var timeElapsedFormatted = ""

    private var gameModel: GameModel
    private let timeCounter: TimeCounterProtocol
    private var timeCounterSubscription: Task<Void, Never>?
    
    private let boardBuilder: BoardBuilder
    private let wonGamesRepository: WonGamesRepositoryProtocol
    private let exitGame: () -> Void
    
    public init(
        gameModel: GameModel,
        timeCounter: TimeCounterProtocol,
        boardBuilder: BoardBuilder = .init(),
        wonGamesRepository: WonGamesRepositoryProtocol,
        exitGame: @escaping () -> Void
    ) {
        self.gameModel = gameModel
        self.timeCounter = timeCounter
        self.boardBuilder = boardBuilder
        self.wonGamesRepository = wonGamesRepository
        self.exitGame = exitGame

        let gameState = gameModel.state
        self.gameState = gameState        
        self.board = boardBuilder.make(from: gameState)
    }
    
    func onTask() async {
        timeCounter.start()
        await subscribeToTimeCounter()
    }
    
    func onCellTap(_ position: Position) {
        guard !gameState.won else { return }

        gameModel.updatePosition(position)
        gameState = gameModel.state
        board = boardBuilder.make(from: gameState)
        
        if gameState.won { handleWonGame() }
    }
    
    func onReset() {
        timeCounter.stop()
        gameModel.resetGame()
        gameState = gameModel.state
        board = boardBuilder.make(from: gameState)

        timeCounter.stop()
    }
    
    func onExit() {
        timeCounter.stop()
        exitGame()
    }
}

private extension GameViewModel {
    func subscribeToTimeCounter() async {
        for await value in timeCounter.timeElapsedStream {
            timeElapsedFormatted = value.formatted(.timeCounter)
        }
    }

    func handleWonGame() {
        let timeElapsed = timeCounter.timeElapsed
        timeCounter.stop()
        
        Task {
            try await wonGamesRepository.saveGame(
                WonGameInfo(
                    timeElapsed: timeElapsed,
                    positions: Array(gameState.placedQueens)
                )
            )
        }
    }
}
