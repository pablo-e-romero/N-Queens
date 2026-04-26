//
//  TimeManagerMock.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Domain
import Foundation

@MainActor
public final class TimeManagerMock: TimeManagerProtocol {
    public var onTimeUpdate: ((_ formattedTime: String) -> Void)?
    public private(set) var timeElapsed: TimeInterval = 0

    public private(set) var startTimerCallCount = 0
    public private(set) var stopTimerCallCount = 0

    public var stubbedFormattedTime: String = "00:00"

    public init() {}
    
    public func startTimer() {
        startTimerCallCount += 1
    }

    public func stopTimer() {
        stopTimerCallCount += 1
    }

    public func simulateTick() {
        onTimeUpdate?(stubbedFormattedTime)
    }
}
