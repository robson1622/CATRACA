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
    @State var directions : DirectionsModel? = nil
    @State var routePoints : [CLLocationCoordinate2D] = []
    @State var searchTextDestination : String = ""
    @State var searchTextMyPosition : String = ""
    @State var myPosition : LocationModel? = nil
    @State var statusOfLoading : StatesOfLoad = .idle
    @State var showLoading : Bool = true
    
    @State var awaitResponse : Bool = false
    @State var routeAndDirectionsHasUpdated : Bool = false
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
                        LogOfTripsView(route: $route,direction: $directions,makeThisRouteAgain: $routeAndDirectionsHasUpdated )
                    }
                    else if menuState == .newTrip {
                        InformationsOfTripView(catracaIsConnected: false, route: $route,directions: $directions, trip: nil)
                    }
                    
                    VStack {
                        Spacer()
                        menu
                            .padding(.top, 30)
                            .shadow(radius: 10)
                            .padding(.bottom,10)
                    }
                    if awaitResponse{
                        VStack{
                            Text("Searching for \n travel route...")
                                .font(.title2)
                                .foregroundStyle(Color.black)
                                .padding()
                            SpinningCatraca()
                                .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .background(Color.branco)
                        .shadow(radius: 10)
                        .cornerRadius(16)
                        .padding(60)
                            
                    }
                    
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
        .onChange(of: routeAndDirectionsHasUpdated){ newValue in
            if newValue{
                routePoints.removeAll()
                if let route = route{
                    for i in 0..<route.listOfPoints.count{
                        routePoints.append(route.listOfPoints[i].toCLLocationCoordinate2D())
                    }
                    startPoint = route.out.position?.toCLLocationCoordinate2D()
                    endPoint = route.finish.position?.toCLLocationCoordinate2D()
                    map?.removePoints()
                    map?.updateMarkers(start: startPoint, end: endPoint)
                    menuState = .none
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
                    let start = LocationModel(local: "",position: startPoint!)
                    let end = LocationModel(local: "",position:endPoint!)
                    awaitResponse = true
                    if startPoint != nil && endPoint != nil{
                        
                        if let origin = startPoint, let destination = endPoint{
                            fetchGoogleRoutes( origin: origin, destination: destination){ response in
                                switch response {
                                case .success(let paths):
                                    DispatchQueue.main.async{
                                        var listOfPoints : [PointModel] = []
                                        for path in paths{
                                            listOfPoints.append(PointModel(position: path))
                                        }
                                        let distance = calculateTotalDistance(points: listOfPoints)
                                        let duration = Int((distance) / 5)
                                        var safeRoute = RouteModel(id: UUID().uuidString, out: start, finish: end, date: Date(), listOfPoints: listOfPoints, distance: distance, duration: duration)
                                        routePoints = paths
                                        route = safeRoute
                                    }
                                case .failure(let error):
                                    DispatchQueue.main.async {
                                        // Trata o erro adequadamente
                                        print("Erro ao buscar rotas: \(error.localizedDescription)")
                                    }
                                }
                            }
                            fetchDirections(from: origin, to: destination){ response in
                                switch response {
                                case .success(let infor):
                                    DispatchQueue.main.sync{
                                        directions = infor
                                        awaitResponse = false
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                                
                            }
                        }
                        
                    }
                }){
                    Image(systemName: "point.bottomleft.forward.to.arrow.triangle.scurvepath.fill")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.branco)
                        .frame(width:48,height: 48)
                        .background(Color.verde2)
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
                        .foregroundStyle(menuState == .logOfTrips ? Color.branco : Color.branco2)
                        .frame(width:48,height: 48)
                        .background(menuState == .logOfTrips ? Color.verde : Color.preto3)
                        .cornerRadius(16)
                }
                if startPoint != nil && endPoint != nil && route != nil && directions != nil{
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
                            .foregroundStyle(menuState == .newTrip ? Color.branco : Color.branco2)
                            .frame(width:48,height: 48)
                            .background(menuState == .newTrip ? Color.verde : Color.preto3)
                            .cornerRadius(16)
                    }
                }
                
                
            }
            .padding(8)
            .background(Color.branco)
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
