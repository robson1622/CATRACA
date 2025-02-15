//
//  ContentView.swift
//  Bluetooth App
//
//  Created by Robson Borges on 24/01/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    @State var connected : Bool = false
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Teste de lista de dispositivos bluetooth")
            
            BluetoothDeviceListView(connected: $connected, bluetoothManager: bluetoothManager)
            
            Button( action:{
                bluetoothManager.startScanning()
            }){
                Text("Tap to search")
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
