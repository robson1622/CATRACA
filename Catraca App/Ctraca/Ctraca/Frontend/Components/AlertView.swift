//
//  AlertView.swift
//  Ctraca
//
//  Created by Robson Borges on 09/11/24.
//

import SwiftUI

struct AlertView: View {
    @Binding var show: Bool
    let text: String
    let success: Bool
    
    // Propriedade para animar a escala vertical
    @State private var scale: CGFloat = 0
    
    var body: some View {
        if show {
            HStack {
                Spacer()
                VStack {
                    Image(systemName: success ? "checkmark.circle.fill" : "x.circle.fill")
                        .foregroundStyle(success ? .blue : .red)
                    Text(text)
                        .foregroundStyle(success ? .blue : .red)
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }
            .padding()
            .background(success ? Color.blue.opacity(0.2) : Color.red.opacity(0.2))
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .scaleEffect(y: scale, anchor: .center) // Aplica o efeito de escala na altura
            .onAppear {
                // Anima o alerta para aparecer
                withAnimation(.spring()) {
                    scale = 1
                }
                
                // Aguarda 4 segundos e, em seguida, anima para desaparecer
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.spring()) {
                        scale = 0
                    }
                    
                    // Define `show` para false após a animação de saída
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        show = false
                    }
                }
            }
        }
    }
}


#Preview {
    AlertView(show:.constant(true),text:"Erro ao tentar amolecer pau via google assitence",success: true)
}
