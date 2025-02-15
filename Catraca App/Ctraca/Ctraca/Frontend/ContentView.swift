//
//  ContentView.swift
//  Ctraca
//
//  Created by Robson Borges on 30/10/24.
//
import UIKit
import SwiftUI
import MapKit
import Mapbox

struct ContentView: View {
    // Variável de estado para controlar o ângulo de rotação
    @State private var rotationAngle: Double = 0
    @State private var initialLocationSet = false
    @State var inicialLocation : String = ""
    @State var finalLocation : String = ""
    @State var map : MapView? = nil
    @State private var startPoint: CLLocationCoordinate2D?
    @State private var endPoint: CLLocationCoordinate2D?
    @State var offlineMapData : URL? = nil
    @StateObject private var bluetoothManager = BluetoothManager()
    @State var connected : Bool = false
    
    @State var location : LocationModel? = nil
    @State var route : RouteModel? = nil
    @State var routePoints : [CLLocationCoordinate2D] = []
    @State var searchTextDestination : String = ""
    @State var searchTextMyPosition : String = ""
    @State var myPosition : LocationModel? = nil
    @State var statusOfLoading : StatesOfLoad = .idle
    @State var showLoading : Bool = true
    
    var body: some View {
        VStack{
            if showLoading{
                loading
            }
            else{
                ZStack {
                    if let mapView = map {
                        mapView
                            .edgesIgnoringSafeArea(.all)
                    }
                    
                    if menuState == .logOfTrips {
                        
                    }
                    else if menuState == .newTrip {
                        InformationsOfTripView(catracaIsConnected: false, route: $route, trip: nil)
                    }
                    
                    VStack {
                        Spacer()
                        menu
                            .padding(.top, 20)
                            .shadow(radius: 10)
                    }
                    .padding(16)
                    
                    
                    //            VStack {
                    //                Spacer()
                    //                Button(action:{
                    ////                    self.showBluetoothConnect = true
                    //                }){
                    //                    Text("Search device")
                    //                        .padding()
                    //                        .background(Color.verde)
                    //                }
                    //                Button(action:{
                    //                    Task{
                    //                        offlineMapData = try await map?.downloadOfflineMap()
                    //                        print("\n Arquivo ZIP criado em: \(offlineMapData) \n")
                    //                    }
                    //                }){
                    //                    Text("Download map")
                    //                        .padding()
                    //                        .background(Color.verde)
                    //                }
                    //                Button(action:{
                    //                    Task{
                    //                        if let offlineMapData = offlineMapData {
                    //                            if FileManager.default.fileExists(atPath: offlineMapData.path) {
                    //                                do {
                    //                                    let zipData = try Data(contentsOf: offlineMapData)
                    //                                    bluetoothManager.dataToSend = zipData
                    //                                    print("Arquivo ZIP carregado com sucesso para envio.")
                    //                                } catch {
                    //                                    print("Erro ao carregar o conteúdo do arquivo ZIP: \(error.localizedDescription)")
                    //                                }
                    //                            } else {
                    //                                print("Arquivo ZIP não encontrado no caminho: \(offlineMapData.path)")
                    //                            }
                    //
                    //                        }
                    //                    }
                    //                }){
                    //                    Text("Send map")
                    //                        .padding()
                    //                        .background(Color.verde)
                    //                }
                    //                Button(action: {
                    //                    // Ação do botão
                    //                    // testar download do mapa
                    //
                    //
                    //                }) {
                    //                    ZStack{
                    //                        Circle()
                    //                            .frame(width: 75)
                    //                            .foregroundStyle(Color.preto2)
                    //                        Image(systemName: "location.circle.fill")
                    //                            .resizable()
                    //                            .frame(width: 80, height: 80)
                    //                            .foregroundStyle(Color.verde)
                    //                            .rotationEffect(.degrees(rotationAngle))
                    //                            .onAppear {
                    //                                withAnimation(Animation.linear(duration: 60).repeatForever(autoreverses: false)) {
                    //                                    rotationAngle = 360 // Gira 360 graus continuamente
                    //                                }
                    //                            }
                    //                        Circle()
                    //                            .frame(width: 20)
                    //                            .foregroundStyle(Color.preto2)
                    //                            .padding(.bottom, 60)
                    //                            .padding(.leading, 60)
                    //                        Image(systemName: "plus.circle.fill")
                    //                            .resizable()
                    //                            .frame(width: 20, height: 20)
                    //                            .foregroundStyle(Color.white)
                    //                            .padding(.bottom, 60)
                    //                            .padding(.leading, 60)
                    //                    }
                    //                    .shadow(radius: 10)
                    //                }
                    //                .padding(36)
                    //            }
                    //            BluetoothDeviceListView(connected:$connected,bluetoothManager: bluetoothManager)
                    //                    .padding(.horizontal,52)
                    //
                    
                }
            }
        }
        .onAppear{
            map = MapView(initialLocationSet: $initialLocationSet, startPoint: $startPoint, endPoint: $endPoint,route:$routePoints)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                withAnimation{
                    showLoading = false
                }
            }
        }
        
    }
    
    @State var showMap: Bool = true
    enum MenuState: String, CaseIterable{
        case newTrip
        case logOfTrips
        case none
    }
    @State var menuState : MenuState = .none
    var menu: some View{
        
        VStack{
            if startPoint != nil && endPoint != nil && menuState == .none{
                Button(action:{
                    let testOfDirections = false
                    let start = LocationModel(local: "Start test",position: startPoint!)
                    let end = LocationModel(local: "End test",position:endPoint!)
                    if testOfDirections{
                        if let origin = startPoint, let destination = endPoint{
                            fetchDirections(from: origin, to: destination){ response in
                                print(response)
                            }
                        }
                    }
                    else if startPoint != nil && endPoint != nil{
                        route = RouteModel(id: UUID().uuidString, out: start, finish: end, date: Date(), listOfPoints: [], distance: 0.00, duration: 0)
                        if let origin = startPoint, let destination = endPoint{
                            fetchGoogleRoutes( origin: origin, destination: destination){ response in
                                switch response {
                                case .success(let paths):
                                    DispatchQueue.main.async {
                                        // Atualiza a variável no thread principal, se necessário
                                        for path in paths{
                                            route?.listOfPoints.append(PointModel(position: path))
                                        }
                                        
                                        //map?.makeCoordinator().drawRoute(with: paths)
                                        routePoints = paths
                                        map?.numberOfPoints = 0
                                    }
                                case .failure(let error):
                                    DispatchQueue.main.async {
                                        // Trata o erro adequadamente
                                        print("Erro ao buscar rotas: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                        
                    }
                }){
                    Image(systemName: "point.bottomleft.forward.to.arrow.triangle.scurvepath.fill")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.verde)
                        .frame(width:48,height: 48)
                        .background(Color.preto2)
                        .cornerRadius(16)
                }
            }
            HStack{
                Button(action: {
                    if menuState == .logOfTrips{
                        menuState = .none
                    }
                    else{
                        menuState = .logOfTrips
                    }
                }) {
                    Image(systemName: "list.clipboard.fill")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(menuState == .logOfTrips ? Color.preto2 : Color.branco)
                        .frame(width:48,height: 48)
                        .background(menuState == .logOfTrips ? Color.verde : Color.preto2)
                        .cornerRadius(16)
                }
                if startPoint != nil && endPoint != nil{
                    Button(action: {
                        if menuState == .newTrip{
                            menuState = .none
                        }
                        else{
                            menuState = .newTrip
                        }
                        
                    }) {
                        Image(systemName: "location.circle.fill")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(menuState == .newTrip ? Color.preto2 : Color.branco)
                            .frame(width:48,height: 48)
                            .background(menuState == .newTrip ? Color.verde : Color.preto2)
                            .cornerRadius(16)
                    }
                }
                
                
            }
            .padding(.horizontal,16)
            .padding(.vertical, 8)
            .background(Color.preto3)
            .cornerRadius(16)
            
        }
    }
    // Variável de estado para controlar a região do mapa
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var loading : some View{
        VStack{
            Spacer()
            SpinningCatraca()
            Text("Catraca App.")
                .font(.subheadline)
                .bold()
                .foregroundStyle(Color.preto2.opacity(0.6))
            Spacer()
            
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                Text("Version: \(appVersion)")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(Color.preto2.opacity(0.3))
                Text("Build: \(buildNumber)")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(Color.preto2.opacity(0.3))
                    .padding(.bottom,24)
                
            } else {
                Text("Não foi possível obter a versão do app.")
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ocupa toda a tela
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.verde, .verde2]), // Cores do degradê
                        startPoint: .topLeading, // Início do degradê
                        endPoint: .bottomTrailing // Fim do degradê
                    )
                )
        .edgesIgnoringSafeArea(.all)
    }
}





#Preview {
    ContentView()
}
