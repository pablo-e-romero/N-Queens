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

    // MARK: - Helpers

    func makeViewModel(
        boardSize: Int = 4,
        onExitGame: @escaping () -> Void = {}
    ) -> (GameViewModel, TimeManagerMock, WonGamesRepositoryMock) {
        let timeManager = TimeManagerMock()
        let repository = WonGamesRepositoryMock()
        let viewModel = GameViewModel(
            gameModel: GameModel(boardSize: boardSize),
            timeManager: timeManager,
            wonGamesRepository: repository,
            exitGame: onExitGame
        )
        return (viewModel, timeManager, repository)
    }

    // MARK: - Timer

    @Test func onAppearStartsTimer() {
        let (sut, timeManager, _) = makeViewModel()
        sut.onAppear()
        #expect(timeManager.startTimerCallCount == 1)
    }

    @Test func onExitStopsTimerAndFiresAction() {
        var exitFired = false
        let (sut, timeManager, _) = makeViewModel(onExitGame: { exitFired = true })
        sut.onExit()
        #expect(timeManager.stopTimerCallCount == 1)
        #expect(exitFired)
    }

    @Test func onResetStopsAndRestartsTimer() {
        let (sut, timeManager, _) = makeViewModel()
        sut.onReset()
        #expect(timeManager.stopTimerCallCount == 1)
        #expect(timeManager.startTimerCallCount == 1)
    }

    @Test func timeTickForwardsFormattedTime() {
        let (sut, timeManager, _) = makeViewModel()
        timeManager.stubbedFormattedTime = 125
        timeManager.simulateTick()
        #expect(sut.timeElapsedFormatted == "02:05.0")
    }

    // MARK: - Board

    @Test func initialBoardMatchesBoardSize() {
        let (sut, _, _) = makeViewModel(boardSize: 5)
        #expect(sut.board.count == 5)
        #expect(sut.board.allSatisfy { $0.count == 5 })
    }

    @Test func onCellTapPlacesQueen() {
        let (sut, _, _) = makeViewModel()
        sut.onCellTap(Position(row: 0, column: 0))
        #expect(sut.gameState.placedQueensCount == 1)
        #expect(sut.board[0][0].hasQueen)
    }

    @Test func onCellTapTogglesQueenOff() {
        let (sut, _, _) = makeViewModel()
        let pos = Position(row: 1, column: 1)
        sut.onCellTap(pos)
        sut.onCellTap(pos)
        #expect(sut.gameState.placedQueensCount == 0)
    }

    @Test func onResetClearsBoard() {
        let (sut, _, _) = makeViewModel()
        sut.onCellTap(Position(row: 0, column: 1))
        sut.onReset()
        #expect(sut.gameState.placedQueensCount == 0)
        #expect(sut.board.allSatisfy { $0.allSatisfy { !$0.hasQueen } })
    }

    // MARK: - Win

    @Test func winningGameStopsTimerAndFiresAction() {
        let (sut, timeManager, _) = makeViewModel()
        placeWinningSolution(on: sut)
        #expect(sut.gameState.won)
        #expect(timeManager.stopTimerCallCount == 1)
    }

    @Test func winningGameSavesToRepository() async throws {
        let (sut, _, repository) = makeViewModel()
        placeWinningSolution(on: sut)
        // Let the internal Task complete on the main actor
        try await Task.sleep(for: .milliseconds(10))
        #expect(repository.saveGameCallCount == 1)
        #expect(repository.savedGames.first?.positions.count == 4)
    }

    @Test func repositoryNotCalledBeforeWinning() async throws {
        let (sut, _, repository) = makeViewModel()
        sut.onCellTap(Position(row: 0, column: 1))
        try await Task.sleep(for: .milliseconds(10))
        #expect(repository.saveGameCallCount == 0)
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
