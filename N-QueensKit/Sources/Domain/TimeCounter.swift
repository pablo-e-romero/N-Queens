//
//  TimeCounterProtocol.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Foundation

public protocol TimeCounterProtocol: Sendable, AnyObject {
    var timeElapsedStream: AsyncStream<TimeInterval> { get }
    var timeElapsed: TimeInterval { get }

    func start()
    func stop()
}
