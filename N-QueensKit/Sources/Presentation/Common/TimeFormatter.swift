//
//  TimeFormatter.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

import Foundation

struct TimeFormatter {
    static func formattedTime(_ timeElapsed: TimeInterval) -> String {
        let totalSeconds = Int(timeElapsed)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        let tenths = Int((timeElapsed - Double(totalSeconds)) * 10)
        return String(format: "%02d:%02d.%d", minutes, seconds, tenths)
    }
}
