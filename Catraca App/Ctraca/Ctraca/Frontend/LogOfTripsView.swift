//
//  LogOfTripsView.swift
//  Ctraca
//
//  Created by Robson Borges on 13/11/24.
//

import SwiftUI

struct LogOfTripsView: View {
    @State var showRoutes : Bool = false
    @State var tripRoutView : Bool = false
    
    @State var showRouteView : Bool = false
    @State var routeToView : RouteModel?
    @State var showTripView : Bool = false
    @State var tripToView : TripModel?
    
    @State var listOfRoutes : [RouteModel] = []
    @State var listOfDirections : [DirectionsModel] = []
    
    @State var listOfTrips : [TripModel] = []
    
    @State var routeToMakeAgain : RouteModel? = nil
    @Binding var route : RouteModel?
    @Binding var direction : DirectionsModel?
    @Binding var makeThisRouteAgain : Bool
    var body: some View {
        VStack{
            ZStack{
                if let routemodel = routeToView, showRouteView{
                    RouteView(showTrip: $showRouteView,routeResponse: $routeToMakeAgain, route: routemodel)
                }
                else if let tripmodel = tripToView, showTripView {
                    TripView(showTrip: $showTripView,routeResponse: $routeToMakeAgain, trip: tripmodel)
                }
                else{
                    VStack{
                        TextModelsViews(text: "Trips and routes recorded", fontType: .largeTextBold)
                            .padding(16)
                        
                        HStack{
                            Button(action: {
                                showRoutes = true
                            }){
                                Text("Routes")
                                    .font(.callout)
                                    .bold()
                                    .foregroundStyle(showRoutes ? Color.preto3 : Color.gray)
                                    .frame(width: 100, height: 30)
                                    .padding(6)
                                    .background(showRoutes ? Color.verde : Color.branco3.opacity(0.3))
                                    .cornerRadius(12)
                            }
                            Button(action: {
                                showRoutes = false
                            }){
                                Text("Trips")
                                    .font(.callout)
                                    .bold()
                                    .foregroundStyle(!showRoutes ? Color.preto3 : Color.gray)
                                    .frame(width: 100, height: 30)
                                    .padding(6)
                                    .background(!showRoutes ? Color.verde : Color.branco3.opacity(0.5))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(8)
                        .background(Color.branco2.opacity(0.5))
                        .cornerRadius(18)
                        
                        ScrollView{
                            if showRoutes{
                                routes
                            }
                            else{
                                trips
                            }
                        }
                        Spacer()
                        
                    }
                }
            }
            
        }
        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .background(Color.branco)
        .onChange(of: showRoutes){newValue in
            saveLastTabView()
        }
        .onChange(of: showTripView){ newValue in
            if !newValue{
                self.makeAnRouteOfHere()
            }
            
        }
        .onChange(of: showRouteView){ newValue in
            if !newValue{
                self.makeAnRouteOfHere()
            }
        }
        .onAppear(){
            listOfRoutes = ArchiveController.shared.loadRoutes()
            listOfDirections = ArchiveController.shared.loadDirections()
            loadLastTabView()
            makeThisRouteAgain = false
        }
    }
    
    
    var routes : some View{
        VStack{
            ForEach(listOfRoutes.indices, id: \.self){ index in
                let routeAux = listOfRoutes[index]
                let title = "\(routeAux.out.local) - \(routeAux.finish.local)"
                let date = routeAux.date.formatDate()
                let distance = String(format: "%.0f",routeAux.distance)
                Button(action:{
                    showRouteView = true
                    showTripView = false
                    routeToView = routeAux
                }){
                    ListElemntView(title: title , date: date , duration:  "\(distance)m",distanceIcon: true)
                }
                if !(index == (listOfRoutes.count - 1)){
                    Divider()
                }
            }
        }
        .padding(8)
        .background(Color.branco2.opacity(0.5))
        .cornerRadius(16)
        .padding(24)
    }
    
    var trips : some View{
        VStack{
            ForEach(listOfTrips.indices, id: \.self){ index in
                let tripAux = listOfTrips[index]
                let duration = Double(tripAux.endDate.difference(tripAux.endDate)).toHourAndMinuteString()
                let date = tripAux.startDate.formatDate()
                let title = "\(tripAux.startLocal) - \(tripAux.endLocal)"
                Button(action:{
                    showRouteView = false
                    showTripView = true
                    tripToView = tripAux
                }){
                    ListElemntView(title: title, date: date, duration: duration)
                }
                Divider()
            }
        }
        .padding(8)
        .background(Color.branco2.opacity(0.5))
        .cornerRadius(16)
        .padding(24)
    }
    private let key = "showRoute"
    private func saveLastTabView() {
        UserDefaults.standard.set(showRoutes, forKey: key)
    }

    private func loadLastTabView() {
        showRoutes = UserDefaults.standard.bool(forKey: key)
    }
    private func makeAnRouteOfHere(){
        if let replay = routeToMakeAgain{
            route = replay
            for i in 0..<listOfRoutes.count{
                if listOfRoutes[i].id == replay.id{
                    if i < listOfDirections.count{
                        direction = listOfDirections[i]
                    }
                }
            }
            
        }
        makeThisRouteAgain = true
    }
}
    


#Preview {
    LogOfTripsView(route:.constant(exempleOfRoute),direction: .constant(exampleDirections),makeThisRouteAgain: .constant(false))
}
