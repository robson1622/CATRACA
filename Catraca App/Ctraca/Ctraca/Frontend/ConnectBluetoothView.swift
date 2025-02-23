//
//  ConnectBluetoothView.swift
//  Ctraca
//
//  Created by Robson Borges on 12/11/24.
//

import SwiftUI
import Foundation

struct ConnectBluetoothView: View {
    @Binding var route : RouteModel?
    @Binding var showTab : Bool
    @State var offlineMapData : URL
    @StateObject private var bluetoothManager = BluetoothManager()
    @State var connected : Bool = true
    @State var showAlert : Bool = false
    
    let textSucess = "Successful connection"
    let textError = "Error when trying to connect"
    let titleText = "Connect\nwith CATRACA"
    var body: some View {
        VStack{
            ZStack{
                HStack{
                    BackButton(onTap: {
                        showTab = false
                    })
                    Spacer()
                }
                
                Text(titleText)
                    .font(.title2)
                    .bold()
                    .padding(24)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.branco)
            }
            HStack{
                Text("SET THE BLUETOOTH OF CATRACA COMPUTER")
                    .font(.subheadline)
                    .foregroundStyle(Color.branco3)
                    .padding(.vertical,4)
                Spacer()
            }
            HStack{
                Text("Set in the CATRACA to receive route mode")
                    .font(.title3)
                    .foregroundStyle(Color.white)
                Spacer()
            }
            
            if !connected{
                VStack{
                    VStack{
                        ZStack{
                            HStack{
                                Spacer()
                                Button(action:{
                                    bluetoothManager.startScanning()
                                }){
                                    Image(systemName: "arrow.trianglehead.counterclockwise.rotate.90")
                                        .padding(6)
                                        .foregroundStyle(Color.verde)
                                        .font(.headline)
                                        .background(Color.verde.opacity(0.3))
                                        .cornerRadius(8)
                                        .padding(.horizontal,16)
                                }
                            }
                            HStack{
                                Text("List of devices")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.verde)
                                    .padding(.vertical,24)
                                    .fontWeight(.semibold)
                            }
                        }
                        BluetoothDeviceListView(connected: $connected,bluetoothManager: bluetoothManager)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 350)
                    .background(Color.preto3)
                    .cornerRadius(16)
                }
                .padding(.vertical,24)
            }
            else{
                Button(action:{
                    if let route = route{
                        bluetoothManager.sendFile(route)
                    }
                    //bluetoothManager.sendJson(fileName: "test.json")
                }){
                    Text("Tap to test send file json")
                        .font(.headline)
                        .foregroundStyle(Color.verde)
                        .padding()
                        .background(Color.verde.opacity(0.3))
                        .cornerRadius(16)
                }
            }
            AlertView(show: $showAlert, text: connected ? textSucess : textError, success: connected)
            
            
            Spacer()
            if connected{
                TryAgainButton(text: "Connect again", onTap: {
                    connected = false
                })
            }
            ShareButton(text: "Send for CATRACA", onTap: {
                
            }, disabled: !connected)
            
            Rectangle()
                .foregroundStyle(Color.clear)
                .frame(height: 60)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color.preto2)
        .onChange(of: connected) { newValue in
            if newValue{
                showAlert = true
            }
        }
        
    }
    
    var connect : some View{
        VStack{
            
        }
    }
    
    
}

#Preview {
    ConnectBluetoothView(route: .constant(exempleOfRoute),showTab:.constant(true),offlineMapData: URL(filePath: "JXQBVXQH")!)
}
