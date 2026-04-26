//
//  N_QueensApp.swift
//  N-Queens
//
//  Created by Pablo Romero on 17/04/2026.
//

import SwiftUI
import Presentation

@main
struct N_QueensApp: App {
    static let dependencies: DependenciesContainer = .live
    
    var body: some Scene {
        WindowGroup {
            GameFlow(dependencies: Self.dependencies)
        }
    }
}
