//
//  ProgressBar.swift
//  Ctraca
//
//  Created by Robson Borges on 12/11/24.
//

import SwiftUI

struct ProgressBar: View {
    
    let percent : Double
    
    var body: some View {
        VStack{
            ZStack(alignment: .leading){
                Rectangle()
                    .foregroundStyle(Color.preto3)
                    .frame(width: 100,height: 10)
                    .cornerRadius(5)
                HStack{
                    Rectangle()
                        .foregroundStyle(Color.verde)
                        .frame(width: percent,height: 10)
                        .cornerRadius(5)
                }
            }
            Text(String(format: "%.1f", percent) + "%")
                .font(.headline)
        }
    }
}

#Preview {
    ProgressBar(percent: 12.35)
}
