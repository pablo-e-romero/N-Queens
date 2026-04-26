//
//  WonGamesRepository.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Foundation
import Domain

public actor WonGamesRepository: WonGamesRepositoryProtocol {
    private let userDefaults: UserDefaults
    private let key = "wonGames"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func saveGame(_ game: WonGameInfo) async throws {
        var games = try await fetchGames()
        games.append(game)
        let data = try encoder.encode(games)
        userDefaults.set(data, forKey: key)
    }

    public func fetchGames() async throws -> [WonGameInfo] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        return try decoder.decode([WonGameInfo].self, from: data)
    }
}
