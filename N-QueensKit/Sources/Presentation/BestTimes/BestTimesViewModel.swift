//
//  BestTimesViewModel.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Domain
import Foundation
import Observation

public protocol BestTimesViewModelFactory {
    func makeBestTimesViewModel() -> BestTimesViewModel
}

@Observable
public final class BestTimesViewModel {
    struct WonGameInfoDisplayModel {
        let formattedTime: String
        let boardSize: String
    }

    enum State {
        case loading
        case empty
        case error
        case loaded([WonGameInfoDisplayModel])
    }

    private(set) var state: State = .loading
    private(set) var isLoading = false

    private let wonGamesRepository: WonGamesRepositoryProtocol

    public init(wonGamesRepository: WonGamesRepositoryProtocol) {
        self.wonGamesRepository = wonGamesRepository
    }

    func onTask() async {
        state = .loading
        
        do {
            let games = try await wonGamesRepository
                .fetchGames()
                .sorted { $0.timeElapsed < $1.timeElapsed }
                .map(WonGameInfoDisplayModel.init(with:))
            
            state = games.isEmpty ? .empty : .loaded(games)
        } catch {
            state = .error
        }
    }
}

private extension BestTimesViewModel.WonGameInfoDisplayModel {
    init(with domain: WonGameInfo) {
        self = .init(
            formattedTime: domain.timeElapsed.formatted(.timeCounter),
            boardSize: "\(domain.positions.count)"
        )
    }
}
