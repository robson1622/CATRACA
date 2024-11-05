//
//  ContentView.swift
//  Ctraca
//
//  Created by Robson Borges on 30/10/24.
//
import UIKit
import SwiftUI
import MapKit

struct ContentView: View {
    // Variável de estado para controlar o ângulo de rotação
    @State private var rotationAngle: Double = 0
    @State private var initialLocationSet = false
    @State var inicialLocation : String = ""
    @State var finalLocation : String = ""
    
    var body: some View {
        ZStack {
            VStack{
                if showMap {
                    MapView(initialLocationSet: $initialLocationSet)
                        .edgesIgnoringSafeArea(.all)
                }
            }
            VStack {
                picker
                    .padding(.top, 56)
                    .shadow(radius: 10)
                Spacer()
            }
            .padding(24)
            VStack {
                Spacer()
                Button(action: {
                    // Ação do botão
                }) {
                    ZStack{
                        Circle()
                            .frame(width: 75)
                            .foregroundStyle(Color.preto2)
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(Color.verde)
                            .rotationEffect(.degrees(rotationAngle))
                            .onAppear {
                                withAnimation(Animation.linear(duration: 60).repeatForever(autoreverses: false)) {
                                    rotationAngle = 360 // Gira 360 graus continuamente
                                }
                            }
                        Circle()
                            .frame(width: 20)
                            .foregroundStyle(Color.preto2)
                            .padding(.bottom, 60)
                            .padding(.leading, 60)
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.white)
                            .padding(.bottom, 60)
                            .padding(.leading, 60)
                    }
                    .shadow(radius: 10)
                }
                .padding(36)
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.preto2)
    }
    
    @State var showMap: Bool = true
    var picker: some View{
        HStack{
            Button(action: {
                showMap.toggle()
                if showMap{
                    initialLocationSet = false
                }
            }) {
                Text("Show Map")
                    .bold()
                    .foregroundColor(showMap ? .black : .white)
                    .padding()
                    .background( showMap ? Color.verde : Color.preto3)
            }
            
            Button(action: {
                showMap.toggle()
            }) {
                Text("Old Trips")
                    .bold()
                    .foregroundColor(!showMap ? .black : .white)
                    .padding()
                    .background( !showMap ? Color.verde : Color.preto3)
            }
        }
        .background(Color.preto3)
        .cornerRadius(10)
    }
    // Variável de estado para controlar a região do mapa
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
}





#Preview {
    ContentView()
}
