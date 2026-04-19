//
//  GameModel.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import Observation

@Observable
final class GameModel {
    let boardSize: Int
    let restartGame: () -> Void
    
    init(
        boardSize: Int = 4,
        restartGame: @escaping () -> Void
    ) {
        self.boardSize = boardSize
        self.restartGame = restartGame
    }
    
    func onRestartGame() {
        restartGame()
    }
}
