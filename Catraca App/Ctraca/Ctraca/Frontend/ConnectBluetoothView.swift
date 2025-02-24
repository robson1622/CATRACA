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
    @Binding var directions : DirectionsModel?
    @Binding var showTab : Bool
    @State var offlineMapData : URL
    @StateObject private var bluetoothManager = BluetoothManager()
    @State var connected : Bool = true
    @State var showAlert : Bool = false
    
    @State var stateOfSend : String = ""
    let textSucess = "Successful connection"
    let textError = "Error when trying to connect"
    let titleText = "Connect\nwith CATRACA"
    
    @State var sendRouteToggle : Bool = false
    @State var sendDirectionsToggle : Bool = false
    @State var sending : Bool = false
    @State var progressBar : Int = 0
    @State var succes : Bool = false
    var body: some View {
        VStack{
            ZStack{
                HStack{
                    BackButton(onTap: {
                        showTab = false
                    })
                    Spacer()
                }
                
                TextModelsViews(text: titleText, fontType: .title)
                    .padding(24)
                    .multilineTextAlignment(.center)
            }
            HStack{
                TextModelsViews(text: "CONFIGURE THE SEND", fontType: .divider)
                Spacer()
            }
            HStack{
                TextModelsViews(text: "Set the bluetooth of CATRACA computer.", fontType: .body)
                Spacer()
            }
            HStack{
                TextModelsViews(text: "Send route", fontType: .body)
                Spacer()
                Toggle("", isOn: $sendRouteToggle)
            }
            .padding(6)
            .padding(.horizontal, 4)
            .background(Color.branco2)
            .cornerRadius(16)
            
            HStack{
                TextModelsViews(text: "Send directions", fontType: .body)
                Spacer()
                Toggle("", isOn: $sendDirectionsToggle)
            }
            .padding(6)
            .padding(.horizontal, 4)
            .background(Color.branco2)
            .cornerRadius(16)
            
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
                                        .foregroundStyle(Color.verde2)
                                        .font(.headline)
                                        .background(Color.verde.opacity(0.3))
                                        .cornerRadius(8)
                                        .padding(.horizontal,16)
                                }
                            }
                            HStack{
                                Text("List of devices")
                                    .font(.title3)
                                    .foregroundStyle(Color.verde2)
                                    .padding(.vertical,24)
                                    .fontWeight(.semibold)
                            }
                        }
                        BluetoothDeviceListView(connected: $connected,bluetoothManager: bluetoothManager)
                            .cornerRadius(16)
                            .padding(12)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .background(Color.branco2)
                    .cornerRadius(16)
                }
                .padding(.vertical,24)
            }
            else if sending{
                VStack{
                    Text("Sending file...")
                        .font(.title2)
                        .foregroundStyle(Color.black)
                    SpinningCatraca()
                    ProgressBar(percent: progressBar)
                }
                .frame(maxWidth: 250,maxHeight: 250)
                .background(Color.branco2)
                .cornerRadius(16)
                .padding(.vertical, 24)
            }
            AlertView(show: $showAlert, text: stateOfSend, success: succes)
            
            
            Spacer()
            if connected && !sending{
                TryAgainButton(text: "Connect again", onTap: {
                    connected = false
                    bluetoothManager.disconectDevice()
                })
            }
            if !sending {
                ShareButton(text: "Send for CATRACA", onTap: {
                    sending = true
                    stateOfSend = ""
                    if let route = route, let directions = directions{
                        ArchiveController.shared.saveFile(route: route, directions: directions)
                    }
                    Task{
                        if let route = route, sendRouteToggle{
                            let response = await bluetoothManager.sendFile(route,percent: $progressBar)
                            
                            if (response == "Error"){
                                stateOfSend = "Error in sending routes.\n"
                                succes = false
                            }
                            else if (response == "Succes"){
                                stateOfSend = "Success in sending routes.\n"
                                succes = true
                            }
                        }
                        if let directions = directions, sendDirectionsToggle{
                            let response = await bluetoothManager.sendFile(directions,percent:$progressBar)
                            if (response == "Error"){
                                stateOfSend += "Error in sending directions."
                                succes = false
                            }
                            else if (response == "Succses"){
                                stateOfSend += "Success in sending directions."
                                succes = true
                            }
                            
                        }
                        sending = false
                        showAlert = true
                    }
                }, disabled: !connected || sending)
            }
            
            
            Rectangle()
                .foregroundStyle(Color.clear)
                .frame(height: 60)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color.branco)
        .onChange(of: connected) { newValue in
            showAlert = true
            if newValue{
                stateOfSend = "Success, bluetooth connected."
                succes = true
            }
            else{
                stateOfSend = "Error, bluetooth not connected."
                succes = false
            }
        }
        
    }
    
    var connect : some View{
        VStack{
            
        }
    }
    
    
}

#Preview {
    ConnectBluetoothView(route: .constant(exempleOfRoute),directions:.constant(exampleDirections),showTab:.constant(true),offlineMapData: URL(filePath: "JXQBVXQH")!)
}
