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
        actions: GameViewModelActions
    ) -> GameViewModel
}

public struct GameViewModelActions {
    public let exitGame: () -> Void

    public struct GameInfo: Identifiable {
        public let id = UUID()
        let gameState: GameState
        let timeElapsedFormatted: String
    }
    
    public let wonGame: (GameInfo) -> Void
    
    public init(
        exitGame: @escaping () -> Void,
        wonGame: @escaping (GameInfo) -> Void
    ) {
        self.exitGame = exitGame
        self.wonGame = wonGame
    }
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
    private let actions: GameViewModelActions
    
    public init(
        gameModel: GameModel,
        timeManager: TimeManagerProtocol,
        boardBuilder: BoardBuilder = .init(),
        wonGamesRepository: WonGamesRepositoryProtocol,
        actions: GameViewModelActions
    ) {
        self.gameModel = gameModel
        self.timeManager = timeManager
        self.boardBuilder = boardBuilder
        self.wonGamesRepository = wonGamesRepository
        self.actions = actions

        let gameState = gameModel.state
        self.gameState = gameState        
        self.board = boardBuilder.make(from: gameState)

        timeManager.onTimeUpdate = { [weak self] timeElapsedFormatted in
            self?.timeElapsedFormatted = timeElapsedFormatted
        }
    }
    
    func onAppear() {
        timeManager.startTimer()
    }
    
    func onCellTap(_ position: Position) {
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
        actions.exitGame()
    }
}

private extension GameViewModel {
    func refresh() {
        gameState = gameModel.state
        board = boardBuilder.make(from: gameState)
    }
    
    func handleWonGame() {
        timeManager.stopTimer()
        
        actions.wonGame(
            GameViewModelActions.GameInfo(
                gameState: gameState,
                timeElapsedFormatted: timeElapsedFormatted
            )
        )
        
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
