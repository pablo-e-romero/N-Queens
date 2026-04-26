//
//  WonGamesRepositoryMock.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Domain
import Foundation

@MainActor
public final class WonGamesRepositoryMock: WonGamesRepositoryProtocol {
    private(set) var saveGameCallCount = 0
    private(set) var savedGames: [WonGameInfo] = []

    private(set) var fetchGameCallCount = 0
    public var stubbedGames: [WonGameInfo] = []
    public var stubbedError: Error?

    public init() {}

    public func saveGame(_ game: WonGameInfo) async throws {
        saveGameCallCount += 1
        if let error = stubbedError { throw error }
        savedGames.append(game)
    }

    public func fetchGame() async throws -> [WonGameInfo] {
        fetchGameCallCount += 1
        if let error = stubbedError { throw error }
        return stubbedGames
    }
}
