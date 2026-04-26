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
    struct WonGameInfo {
        let formattedTime: String
        let boardSize: String
    }

    enum State {
        case loading
        case empty
        case error
        case loaded([WonGameInfo])
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
                .map {
                    WonGameInfo(
                        formattedTime: TimeFormatter.formattedTime($0.timeElapsed),
                        boardSize: "\($0.positions.count)"
                    )
                }
            
            state = games.isEmpty ? .empty : .loaded(games)
        } catch {
            state = .error
        }
    }
}
