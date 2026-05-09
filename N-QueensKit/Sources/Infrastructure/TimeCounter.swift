// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Domain

@MainActor
public final class TimeCounter: TimeCounterProtocol {
    public let timeElapsedStream: AsyncStream<TimeInterval>
    public private(set) var timeElapsed: TimeInterval = 0

    private var timerTask: Task<Void, Never>?
    private let timeElapsedContinuation: AsyncStream<TimeInterval>.Continuation
    private let clock: any Clock<Duration>
    
    public init(clock: any Clock<Duration>) {
        self.clock = clock
        
        let (stream, continuation) = AsyncStream<TimeInterval>.makeStream()
        timeElapsedStream = stream
        timeElapsedContinuation = continuation
    }
    
    public convenience init() {
        self.init(clock: SuspendingClock())
    }
    
    public func start() {
        guard timerTask == nil else { return }
        timeElapsed = 0
        timerTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                try? await clock.sleep(for: .milliseconds(100))
                timeElapsed += 0.1
                timeElapsedContinuation.yield(timeElapsed)
            }
        }
    }
    
    public func stop() {
        timerTask?.cancel()
        timerTask = nil
    }
}
