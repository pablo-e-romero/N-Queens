//
//  GreenPrimaryButtonStyle.swift
//  N-QueensKit
//
//  Created by Pablo Romero on 21/04/2026.
//

import SwiftUI

struct GreenPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3.bold())
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.47, green: 0.73, blue: 0.22),
                        Color(red: 0.38, green: 0.60, blue: 0.16)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == GreenPrimaryButtonStyle {
    static var greenPrimary: GreenPrimaryButtonStyle { .init() }
}
