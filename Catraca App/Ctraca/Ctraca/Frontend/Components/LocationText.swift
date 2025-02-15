//
//  LocationText.swift
//  Ctraca
//
//  Created by Robson Borges on 12/11/24.
//

import SwiftUI

struct LocationText: View {
    enum types{
        case start,end,calendar
    }
    let type : types
    let location : String
    var body: some View {
        HStack{
            Image(systemName: self.getSymbol())
                .font(.title2)
                .foregroundStyle(Color.verde)
                .padding(4)
                .rotationEffect( type != .calendar ? .degrees(90) : .degrees(0))
            Text(location)
                .font(.headline)
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding(8)
        .background(Color.preto3)
        .cornerRadius(16)
    }
    
    private func getSymbol() -> String{
        switch type{
        case .start:
            return "square.and.arrow.up"
        case .end:
            return "square.and.arrow.down"
        case .calendar:
            return "calendar"
        }
    }
}

#Preview {
    LocationText(type: .start,location: "Universidade Tecnológica Federal do Paraná")
}
