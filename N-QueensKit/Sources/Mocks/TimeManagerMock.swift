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
    public var onTimeUpdate: ((_ timeInterval: TimeInterval) -> Void)?
    public private(set) var timeElapsed: TimeInterval = 0

    public private(set) var startTimerCallCount = 0
    public private(set) var stopTimerCallCount = 0

    public var stubbedFormattedTime: TimeInterval = 0

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
