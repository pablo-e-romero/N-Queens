//
//  TimeManager.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Foundation

public protocol TimeManagerProtocol: Sendable, AnyObject {
    var onTimeUpdate: ((_ formattedTime: String) -> Void)? { get set }
    var timeElapsed: TimeInterval { get }

    func startTimer()
    func stopTimer()
}
