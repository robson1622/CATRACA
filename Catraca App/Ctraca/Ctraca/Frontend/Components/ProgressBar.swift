//
//  ProgressBar.swift
//  Ctraca
//
//  Created by Robson Borges on 12/11/24.
//

import SwiftUI

struct ProgressBar: View {
    
    let percent : Int
    
    var body: some View {
        VStack{
            ZStack(alignment: .leading){
                Rectangle()
                    .foregroundStyle(Color.preto3.opacity(0.1))
                    .frame(width: 100,height: 10)
                    .cornerRadius(5)
                HStack{
                    Rectangle()
                        .foregroundStyle(Color.verde)
                        .frame(width: CGFloat(percent),height: 10)
                        .cornerRadius(5)
                }
            }
            Text(String("\(percent)%"))
                .font(.headline)
                .foregroundStyle(Color.gray)
        }
    }
}

#Preview {
    ProgressBar(percent: 12)
}
