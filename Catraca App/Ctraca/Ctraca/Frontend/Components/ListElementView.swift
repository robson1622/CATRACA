//
//  ListElementView.swift
//  Ctraca
//
//  Created by Wendell Borges on 19/02/25.
//

import SwiftUI

struct ListElemntView : View{
    let title : String
    let date : String
    let duration : String
    var distanceIcon : Bool = false
    var body : some View{
        VStack{
            HStack{
                Image(systemName: "mappin.and.ellipse")
                    .font(.callout)
                    .bold()
                    .foregroundStyle(Color.verde)
                TextModelsViews(text: title, fontType: .largeTextBold)
                Spacer()
            }
            HStack{
                HStack{
                    Image(systemName: "calendar")
                        .font(.callout)
                        .foregroundStyle(Color.verde)
                    TextModelsViews(text: date, fontType: .body)
                }
                HStack{
                    Image(systemName: distanceIcon ? "point.forward.to.point.capsulepath" : "clock")
                        .font(.callout)
                        .foregroundStyle(Color.verde)
                    TextModelsViews(text: duration, fontType: .body)
                }
                .padding(.leading,16)
                Spacer()
            }
        }
    }
}

#Preview {
    ListElemntView(title: "Passeio público", date: Date().formatDate(), duration: Double(21.3).toHourAndMinuteString())
}
