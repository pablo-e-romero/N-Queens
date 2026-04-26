//
//  GameSetupViewModel.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import Observation

@Observable
final class GameSetupViewModel {
    var boardSize: Int
    let startGame: (Int) -> Void
    let showBestTimes: () -> Void

    init(
        boardSize: Int = 4,
        startGame: @escaping (Int) -> Void,
        showBestTimes: @escaping () -> Void
    ) {
        self.boardSize = boardSize
        self.startGame = startGame
        self.showBestTimes = showBestTimes
    }

    func onStartGame() {
        startGame(boardSize)
    }

    func onShowBestTimes() {
        showBestTimes()
    }
}
