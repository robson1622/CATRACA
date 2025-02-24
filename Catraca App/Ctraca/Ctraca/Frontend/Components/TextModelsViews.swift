//
//  TextModelsViews.swift
//  Ctraca
//
//  Created by Wendell Borges on 21/02/25.
//

import SwiftUI

struct TextModelsViews: View {
    enum FontType{
        case title,largeTextBold,largeText,divider,body
    }
    let text : String
    let fontType : FontType
    var body: some View {
        switch fontType {
        case .title:
            Text(text)
                .font(.title2)
                .bold()
                .foregroundStyle(Color.preto2)
        case .largeTextBold:
            Text(text)
                .font(.title3)
                .bold()
                .foregroundStyle(Color.preto2)
        case .largeText:
            Text(text)
                .font(.title3)
                .foregroundStyle(Color.preto2)
        case .divider:
            Text(text)
                .font(.headline)
                .foregroundStyle(Color.gray)
        case .body:
            Text(text)
                .font(.body)
                .foregroundStyle(Color.preto2)
        }
        
    }
    
}

#Preview {
    TextModelsViews(text:"Passeios do dédé",fontType: .body)
}
