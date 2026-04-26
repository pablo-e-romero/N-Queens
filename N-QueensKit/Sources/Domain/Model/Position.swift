//
//  Position.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 26/04/2026.
//

public struct Position: Hashable {
    public let row: Int
    public let column: Int
    
    public init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
}
