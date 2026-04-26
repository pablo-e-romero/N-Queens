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
    private(set) var timeElapsedFormatted: String = ""

    private var gameModel: GameModel
    private let timeManager: TimeManagerProtocol
    private let actions: GameViewModelActions
    
    public init(
        gameModel: GameModel,
        timeManager: TimeManagerProtocol,
        actions: GameViewModelActions
    ) {
        self.gameModel = gameModel
        self.timeManager = timeManager
        self.actions = actions
        self.gameState = gameModel.state
        
        timeManager.onTimeUpdate = { [weak self] timeElapsedFormatted in
            self?.timeElapsedFormatted = timeElapsedFormatted
        }
    }
    
    func onAppear() {
        timeManager.startTimer()
    }
    
    func onCellTap(_ position: Position) {
        gameModel.updatePosition(position)
        gameState = gameModel.state
        
        if gameState.won {
            timeManager.stopTimer()
            actions.wonGame()
        }
    }
    
    func onReset() {
        timeManager.stopTimer()
        gameModel.resetGame()
        gameState = gameModel.state
        timeManager.startTimer()
    }
    
    func onExit() {
        timeManager.stopTimer()
        actions.exitGame()
    }
}
