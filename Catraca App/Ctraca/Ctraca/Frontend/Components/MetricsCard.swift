//
//  MetricsCard.swift
//  Ctraca
//
//  Created by Robson Borges on 12/11/24.
//

import SwiftUI

struct MetricsCard: View {
    
    enum Style{
        case time,distance,average,maxspeed
    }
    
    let primary : Bool
    let title : String
    let value : String
    let style : Style
    
    var body: some View {
        HStack{
            ZStack{
                Rectangle()
                    .frame(width: 36,height: 36)
                    .foregroundStyle( primary ? Color.preto2 : Color.verde)
                    .cornerRadius(16)
                
                Image(systemName: self.getIcon())
                    
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(primary ? Color.white : Color.black)
                    
            }
            VStack{
                HStack{
                    Text(title)
                        .bold()
                        .font(.footnote)
                        .foregroundStyle(primary ? Color.preto2 : Color.preto3)
                        .padding(.bottom,-10)
                        
                    Spacer()
                }
                HStack{
                    Text(value)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundStyle(primary ? Color.preto2 : Color.preto3)
                    Spacer()
                }
            }
            
        }
        .padding(.horizontal,12)
        .padding(.vertical,8)
        .background(primary ? Color.verde : Color.verde.opacity(0.2))
        .cornerRadius(16)
    }
    
    private func getIcon() -> String{
        switch style{
            case .time:
                return "clock.fill"
            case .distance:
                return "point.forward.to.point.capsulepath"
            case .average:
                return "slider.vertical.3"
            case .maxspeed:
                return "gauge.with.dots.needle.100percent"
        }
    }
}

#Preview {
    MetricsCard(primary: false, title: "HELLO WORLD!", value: "1h32m53s", style: .time)
}
