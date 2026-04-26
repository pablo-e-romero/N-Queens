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
    public let wonGame: () -> Void
    
    public init(
        exitGame: @escaping () -> Void,
        wonGame: @escaping () -> Void
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
    private let actions: GameViewModelActions
    
    public init(
        gameModel: GameModel,
        timeManager: TimeManagerProtocol,
        boardBuilder: BoardBuilder = .init(),
        actions: GameViewModelActions
    ) {
        self.gameModel = gameModel
        self.timeManager = timeManager
        self.boardBuilder = boardBuilder
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

        if gameState.won {
            timeManager.stopTimer()
            actions.wonGame()
        }
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
}
