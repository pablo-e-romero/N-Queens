//
//  TimeManagerMock.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Domain
import Foundation

@MainActor
public final class TimeCounterMock: TimeCounterProtocol {
    public let timeElapsedStream: AsyncStream<TimeInterval>
    private let timeElapsedContinuation: AsyncStream<TimeInterval>.Continuation

    public private(set) var timeElapsed: TimeInterval = 0

    public private(set) var startCallCount = 0
    public private(set) var stopCallCount = 0

    public init() {
        let (stream, continuation) = AsyncStream<TimeInterval>.makeStream()
        timeElapsedStream = stream
        timeElapsedContinuation = continuation
    }
    
    public func start() {
        startCallCount += 1
    }

    public func stop() {
        stopCallCount += 1
    }

    public func simulateTick(_ timeInterval: TimeInterval) {
        timeElapsedContinuation.yield(timeInterval)
    }
}
