//
//  Colors.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 21/04/2026.
//

import Foundation
import SwiftUI


extension Color {
    enum AppTheme {
        static let primary = Color.white
        static let secondary = Color.white.opacity(0.7)
        
        static let background = Color(red: 0.22, green: 0.22, blue: 0.22)
        static let secondaryBackground = Color(red: 0.13, green: 0.13, blue: 0.13)
        static let tertiaryBackground = Color(red: 0.10, green: 0.10, blue: 0.10)
        
        static let tint = Color(red: 0.47, green: 0.73, blue: 0.22)
        
        static let lightCellBackground = Color(red: 0.941, green: 0.851, blue: 0.710)
        static let darkCellBackground = Color(red: 0.710, green: 0.533, blue: 0.388)
        static let cellForeground = Color(white: 0.96)
        
        static let conflictBackground = Color.red.opacity(0.4)
        static let conflictForeground = Color.red
    }
}

extension CGFloat {
    enum AppTheme {
        static let padding: CGFloat = 16
        static let cornerRadius: CGFloat = 8
    }
}
