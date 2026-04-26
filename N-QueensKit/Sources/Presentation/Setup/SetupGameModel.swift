//
//  SetupGameViewModel.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import Observation

@Observable
final class SetupGameViewModel {
    var boardSize: Int
    let startGame: (Int) -> Void
    
    init(
        boardSize: Int = 4,
        startGame: @escaping (Int) -> Void
    ) {
        self.boardSize = boardSize
        self.startGame = startGame
    }
    
    func onStartGame() {
        startGame(boardSize)
    }
}
