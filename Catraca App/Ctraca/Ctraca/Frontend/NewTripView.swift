//
//  NewTripView.swift
//  Ctraca
//
//  Created by Robson Borges on 31/10/24.
//

import SwiftUI

struct NewTripView: View {
    
    enum Focus {
        case from,to
    }
    
    @FocusState var focus : Focus?
    
    @State var from : String = ""
    @State var to : String = ""
    
    let explainText : String = "Chose local to start and local to end this trip..."
    var body: some View {
        VStack {
            HStack{
                Text(explainText)
                    .font(.title3)
                    .bold()
                Spacer()
            }
            
            HStack{
                TextField("From", text: $from)
                    .focused($focus, equals: .from)
                if focus == .from {
                    Button(action:{
                        from = ""
                    }){
                        Image(systemName: "x.circle.fill")
                            .font(.callout)
                            .foregroundColor(.red)
                    }
                }
                
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            HStack{
                TextField("To", text: $to)
                    .focused($focus, equals: .to)
                if focus == .to {
                    Button(action:{
                        to = ""
                    }){
                        Image(systemName: "x.circle.fill")
                            .font(.callout)
                            .foregroundColor(.red)
                    }
                }
                
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding(24)
    }
}

#Preview {
    NewTripView()
}
