//
//  GameViewModelTests.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Foundation
import Testing
import Domain
import Mocks
@testable import Presentation

@MainActor
struct GameViewModelTests {
    var wonGamesRepository: WonGamesRepositoryMock!
    var timeCounter: TimeCounterMock!
    var sut: GameViewModel!

    init() {
        timeCounter = TimeCounterMock()
        wonGamesRepository = WonGamesRepositoryMock()
    }
    
    func makeViewModel(
        boardSize: Int = 4,
        onExitGame: @escaping () -> Void = {}
    ) -> GameViewModel {
        GameViewModel(
            gameModel: GameModel(boardSize: boardSize),
            timeCounter: timeCounter,
            wonGamesRepository: wonGamesRepository,
            exitGame: onExitGame
        )
    }

    // MARK: - Timer

    @Test func onAppearStartsTimer() {
        let sut = makeViewModel()
        sut.onAppear()
        #expect(timeCounter.startCallCount == 1)
    }

    @Test func onExitStopsTimerAndFiresAction() {
        var exitFired = false
        let sut = makeViewModel(onExitGame: { exitFired = true })
        sut.onExit()
        #expect(timeCounter.stopCallCount == 1)
        #expect(exitFired)
    }

    @Test func onResetStopsAndRestartsTimer() {
        let sut = makeViewModel()
        sut.onReset()
        #expect(timeCounter.stopCallCount == 1)
        #expect(timeCounter.startCallCount == 1)
    }

    // MARK: - GameState

    @Test func initialBoardMatchesBoardSize() {
        let sut = makeViewModel(boardSize: 5)
        #expect(sut.gameState.boardSize == 5)
    }

    @Test func onCellTapPlacesQueen() {
        let sut = makeViewModel()
        sut.onCellTap(Position(row: 0, column: 0))
        #expect(sut.gameState.placedQueensCount == 1)
    }

    @Test func onCellTapTogglesQueenOff() {
        let sut = makeViewModel()
        let pos = Position(row: 1, column: 1)
        sut.onCellTap(pos)
        sut.onCellTap(pos)
        #expect(sut.gameState.placedQueensCount == 0)
    }

    @Test func onResetClearsBoard() {
        let sut = makeViewModel()
        sut.onCellTap(Position(row: 0, column: 1))
        sut.onReset()
        #expect(sut.gameState.placedQueensCount == 0)
    }

    // MARK: - Win

    @Test func winningGameStopsTimerAndFiresAction() {
        let sut = makeViewModel()
        placeWinningSolution(on: sut)
        #expect(sut.gameState.won)
        #expect(timeCounter.stopCallCount == 1)
    }

    @Test func winningGameSavesToRepository() async throws {
        let sut = makeViewModel()
        placeWinningSolution(on: sut)
        // Let the internal Task complete on the main actor
        try await Task.sleep(for: .milliseconds(10))
        #expect(wonGamesRepository.saveGameCallCount == 1)
        #expect(wonGamesRepository.savedGames.first?.positions.count == 4)
    }

    @Test func repositoryNotCalledBeforeWinning() async throws {
        let sut = makeViewModel()
        sut.onCellTap(Position(row: 0, column: 1))
        try await Task.sleep(for: .milliseconds(10))
        #expect(wonGamesRepository.saveGameCallCount == 0)
    }
}

// MARK: - Private

private extension GameViewModelTests {
    // Known valid solution for 4×4
    func placeWinningSolution(on viewModel: GameViewModel) {
        viewModel.onCellTap(Position(row: 0, column: 1))
        viewModel.onCellTap(Position(row: 1, column: 3))
        viewModel.onCellTap(Position(row: 2, column: 0))
        viewModel.onCellTap(Position(row: 3, column: 2))
    }
}
