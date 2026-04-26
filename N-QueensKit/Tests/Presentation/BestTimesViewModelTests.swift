//
//  BestTimesViewModelTests.swift
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
struct BestTimesViewModelTests {

    // MARK: - Helpers

    func makeViewModel() -> (BestTimesViewModel, WonGamesRepositoryMock) {
        let repository = WonGamesRepositoryMock()
        return (BestTimesViewModel(wonGamesRepository: repository), repository)
    }

    func makeWonGame(timeElapsed: TimeInterval, boardSize: Int) -> Domain.WonGameInfo {
        let positions = (0..<boardSize).map { Position(row: $0, column: $0) }
        return Domain.WonGameInfo(timeElapsed: timeElapsed, positions: positions)
    }

    // MARK: - Initial state

    @Test func initialStateIsLoading() {
        let (sut, _) = makeViewModel()
        guard case .loading = sut.state else {
            Issue.record("Expected .loading, got \(sut.state)")
            return
        }
    }

    // MARK: - onTask

    @Test func onTaskFetchesFromRepository() async {
        let (sut, repository) = makeViewModel()
        await sut.onTask()
        #expect(repository.fetchGamesCallCount == 1)
    }

    @Test func onTaskWithEmptyResultSetsEmptyState() async {
        let (sut, _) = makeViewModel()
        await sut.onTask()
        guard case .empty = sut.state else {
            Issue.record("Expected .empty, got \(sut.state)")
            return
        }
    }

    @Test func onTaskWithGamesSetsLoadedState() async {
        let (sut, repository) = makeViewModel()
        repository.stubbedGames = [makeWonGame(timeElapsed: 30, boardSize: 4)]
        await sut.onTask()
        guard case .loaded(let games) = sut.state else {
            Issue.record("Expected .loaded, got \(sut.state)")
            return
        }
        #expect(games.count == 1)
        #expect(games[0].boardSize == "4")
        #expect(games[0].formattedTime == "00:30.0")
    }

    @Test func onTaskSortsGamesByTimeAscending() async {
        let (sut, repository) = makeViewModel()
        repository.stubbedGames = [
            makeWonGame(timeElapsed: 60, boardSize: 4),
            makeWonGame(timeElapsed: 30, boardSize: 4),
            makeWonGame(timeElapsed: 45, boardSize: 4),
        ]
        await sut.onTask()
        guard case .loaded(let games) = sut.state else {
            Issue.record("Expected .loaded, got \(sut.state)")
            return
        }
        #expect(games[0].formattedTime == "00:30.0")
        #expect(games[1].formattedTime == "00:45.0")
        #expect(games[2].formattedTime == "01:00.0")
    }

    @Test func onTaskWithErrorSetsErrorState() async {
        let (sut, repository) = makeViewModel()
        repository.stubbedError = URLError(.badServerResponse)
        await sut.onTask()
        guard case .error = sut.state else {
            Issue.record("Expected .error, got \(sut.state)")
            return
        }
    }

    @Test func boardSizeStringReflectsPositionCount() async {
        let (sut, repository) = makeViewModel()
        repository.stubbedGames = [makeWonGame(timeElapsed: 10, boardSize: 8)]
        await sut.onTask()
        guard case .loaded(let games) = sut.state else {
            Issue.record("Expected .loaded, got \(sut.state)")
            return
        }
        #expect(games[0].boardSize == "8")
    }
}
