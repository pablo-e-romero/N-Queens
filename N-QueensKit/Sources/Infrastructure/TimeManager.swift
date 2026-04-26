// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Domain

@MainActor
public final class TimeManager: TimeManagerProtocol {
    public var onTimeUpdate: ((_ formattedTime: String) -> Void)?

    public private(set) var timeElapsed: TimeInterval = 0 {
        didSet {
            onTimeUpdate?(formatElpasedTime(timeElapsed))
        }
    }
    
    private var timerTask: Task<Void, Never>?

    public init() {}
    
    public func startTimer() {
        guard timerTask == nil else { return }
        timeElapsed = 0
        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(100))
                guard let self else { break }
                self.timeElapsed += 0.1
            }
        }
    }
    
    public func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }
    
    func formatElpasedTime(_ timeElapsed: TimeInterval) -> String {
        let totalSeconds = Int(timeElapsed)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        let tenths = Int((timeElapsed - Double(totalSeconds)) * 10)
        return String(format: "%02d:%02d.%d", minutes, seconds, tenths)
    }
}
