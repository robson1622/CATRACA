//
//  ShareButton.swift
//  Ctraca
//
//  Created by Robson Borges on 09/11/24.
//

import SwiftUI

struct ShareButton: View {
    let text : String
    let onTap : () -> Void
    var disabled : Bool = false
    var body: some View {
        StandardButton(text: text, icon: "square.and.arrow.up.fill", color: .verde, onTap: { onTap() }, disabled: disabled)
    }
}

struct DeleteButton: View {
    let text : String
    let onTap : () -> Void
    var disabled : Bool = false
    var body: some View {
        StandardButton(text: text, icon: "trash.fill", color: .salmao, onTap: { onTap() }, disabled: disabled)
    }
}

struct CancelButton: View {
    let text : String
    let onTap : () -> Void
    var disabled : Bool = false
    var body: some View {
        StandardButton(text: text, icon: "x.circle", color: .salmao, onTap: { onTap() }, disabled: disabled)
    }
}

struct TryAgainButton: View {
    let text : String
    let onTap : () -> Void
    var disabled : Bool = false
    var body: some View {
        StandardButton(text: text, icon: "arrow.trianglehead.counterclockwise.rotate.90", color: .verde2, onTap: { onTap() }, disabled: disabled)
    }
}

struct ConnectButton: View {
    let text : String
    let onTap : () -> Void
    var disabled : Bool = false
    var body: some View {
        StandardButton(text: text, icon: "point.3.filled.connected.trianglepath.dotted", color: .verde, onTap: { onTap() }, disabled: disabled)
    }
}

struct PlayButton: View {
    let text : String
    let onTap : () -> Void
    var disabled : Bool = false
    var body: some View {
        StandardButton(text: text, icon: "play", color: .verde, onTap: { onTap() }, disabled: disabled)
    }
}

struct BackButton : View{
    let onTap : () -> Void
    var body: some View {
        Button(action: {
            onTap()
        }){
            HStack{
                Image(systemName: "chevron.left")
                    .font(.callout)
                    .bold()
                Text("Back")
                    .font(.callout)
                    .bold()
            }
            .foregroundStyle(Color.preto2)
            .padding(.vertical,12)
            .padding(.horizontal,8)
            .background(Color(.verde))
            .cornerRadius(16)
        }
    }
}

struct StandardButton : View{
    let text : String
    let icon : String
    let color : Color
    let onTap : () -> Void
    var disabled : Bool = false
    var body: some View {
        Button(action:{
            if !disabled {
                onTap()
            }
        }){
            HStack{
                Spacer()
                Image(systemName: icon)
                    .foregroundStyle( disabled ? .gray : color)
                Text(text)
                    .foregroundStyle( disabled ? .gray : color)
                Spacer()
            }
            .padding()
            .background( disabled ? .gray.opacity(0.3) : color.opacity(0.2))
            .cornerRadius(16)
        }
    }
}

#Preview {
    ConnectButton(text: "Share this trip" ,onTap: {})
}
