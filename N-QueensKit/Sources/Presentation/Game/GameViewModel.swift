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
    private let timeManager: TimeManagerProtocol
    private let boardBuilder: BoardBuilder
    private let wonGamesRepository: WonGamesRepositoryProtocol
    private let exitGame: () -> Void
    
    public init(
        gameModel: GameModel,
        timeManager: TimeManagerProtocol,
        boardBuilder: BoardBuilder = .init(),
        wonGamesRepository: WonGamesRepositoryProtocol,
        exitGame: @escaping () -> Void
    ) {
        self.gameModel = gameModel
        self.timeManager = timeManager
        self.boardBuilder = boardBuilder
        self.wonGamesRepository = wonGamesRepository
        self.exitGame = exitGame

        let gameState = gameModel.state
        self.gameState = gameState        
        self.board = boardBuilder.make(from: gameState)

        timeManager.onTimeUpdate = { [weak self] in
            self?.timeElapsedFormatted = TimeFormatter.formattedTime($0)
        }
    }
    
    func onAppear() {
        timeManager.startTimer()
    }
    
    func onCellTap(_ position: Position) {
        guard !gameState.won else { return }

        gameModel.updatePosition(position)
        refresh()
        if gameState.won { handleWonGame() }
    }
    
    func onReset() {
        timeManager.stopTimer()
        gameModel.resetGame()
        refresh()
        timeManager.startTimer()
    }
    
    func onExit() {
        timeManager.stopTimer()
        exitGame()
    }
}

private extension GameViewModel {
    func refresh() {
        gameState = gameModel.state
        board = boardBuilder.make(from: gameState)
    }
    
    func handleWonGame() {
        timeManager.stopTimer()
        
        Task {
            try await wonGamesRepository.saveGame(
                WonGameInfo(
                    timeElapsed: timeManager.timeElapsed,
                    positions: Array(gameState.placedQueens)
                )
            )
        }
    }
}
