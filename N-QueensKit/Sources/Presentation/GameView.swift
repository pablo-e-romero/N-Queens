//
//  GameView.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 19/04/2026.
//

import SwiftUI

struct GameView: View {
    @State var model: GameModel
    
    var body: some View {
        Text("board size \(model.boardSize)")
    }
}
