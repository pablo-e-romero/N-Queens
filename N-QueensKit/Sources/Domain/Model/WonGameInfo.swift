//
//  WonGameInfo.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Foundation

public struct WonGameInfo: Codable {
    public let timeElapsed: TimeInterval
    public let positions: [Position]
    
    public init(timeElapsed: TimeInterval, positions: [Position]) {
        self.timeElapsed = timeElapsed
        self.positions = positions
    }
}
