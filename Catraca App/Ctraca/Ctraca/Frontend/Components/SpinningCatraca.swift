//
//  SpinningCatraca.swift
//  Ctraca
//
//  Created by Robson Borges on 23/01/25.
//

import SwiftUI

struct SpinningCatraca: View {
    @State private var rotationAngle: Double = 0 // Ângulo de rotação inicial
    
    var body: some View {
        Image("loading")
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .rotationEffect(.degrees(rotationAngle)) // Aplica o ângulo de rotação
            .onAppear {
                // Animação contínua
                withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
            }
    }
}


#Preview {
    SpinningCatraca()
}
