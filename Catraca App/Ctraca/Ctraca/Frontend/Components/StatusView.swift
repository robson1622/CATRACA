//
//  StatusView.swift
//  Ctraca
//
//  Created by Robson Borges on 09/11/24.
//

import SwiftUI

struct StatusView: View {
    @State private var rotationAngle: Double = 0
    let text : String
    var body: some View {
        HStack{
            Image("loadweel")
                .resizable()
                .frame(width: 30,height: 30)
                .rotationEffect(.degrees(rotationAngle))
                .onAppear {
                    withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                        rotationAngle = 360 // Gira 360 graus continuamente
                    }
                }
            Text(text)
                .bold()
                .foregroundStyle( .verde)
                .multilineTextAlignment(.center)
        }
        .padding(8)
        .background( .preto3 )
        .cornerRadius(23)
    }
}


#Preview {
    StatusView(text:"Connecting...")
}
