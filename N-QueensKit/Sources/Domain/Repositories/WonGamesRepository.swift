//
//  WonGamesRepository.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Foundation

public protocol WonGamesRepositoryProtocol: Sendable {
    func saveGame(_ game: WonGameInfo) async throws
    func fetchGames() async throws -> [WonGameInfo]
}
