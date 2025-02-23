//
//  InformationsOfTripView.swift
//  Ctraca
//
//  Created by Robson Borges on 12/11/24.
//

import SwiftUI

struct InformationsOfTripView: View {
    let catracaIsConnected : Bool
    @State var nextView : Bool = false
    @Binding var route : RouteModel?
    var trip : TripModel?
    var body: some View {
        VStack{
            if nextView{
                ConnectBluetoothView(route: $route,showTab: $nextView,offlineMapData: URL(filePath: "https://teste.com.br")!, connected: false, showAlert: false)
            }
            else{
                Text( trip == nil ? "Informations of Trip" : "Trip")
                    .font(.title2)
                    .bold()
                    .padding(24)
                    .foregroundStyle(Color.branco)
                
                ScrollView{
                    locations
                    
                    metrics
                    
                }
                Spacer()
                buttons
                    .padding(.bottom,60)
                
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color.preto2)
    }
    var locations : some View{
        VStack{
            HStack{
                Text("LOCATIONS")
                    .font(.headline)
                    .foregroundStyle(Color.branco3)
                Spacer()
            }
            if let route = route {
                LocationText(type:.start, location: "\(route.out.local)" )
                LocationText(type:.end, location: "\(route.finish.local)" )
            }
            else if let trip = trip {
                LocationText(type:.start, location: "\(trip.startLocal)" )
                LocationText(type:.end, location: "\(trip.endLocal)" )
                LocationText(type:.calendar, location: "\(self.formatEndDate()!)" )
            }
        }
    }
    
    var metrics : some View{
        VStack{
            HStack{
                Text("METRICS")
                    .font(.headline)
                    .foregroundStyle(Color.branco3)
                Spacer()
            }
            .padding(.top,16)
            
            VStack{
                if let trip = trip{
                    MetricsCard(primary: true, title: "ESTIMATED TIME", value: "\(self.calculateDurationString() ?? "WITHOUT END DATE")", style: .time)
                    MetricsCard(primary: false, title: "DISTANCE", value: "\(trip.distance) km", style: .distance)
                    MetricsCard(primary: false, title: "AVERAGE", value: "\(trip.average) km/h", style: .average)
                    MetricsCard(primary: false, title: "MAX SPEED", value: "\(trip.maxSpeed) km/h", style: .maxspeed)
                }
                else if let route = route{
                    MetricsCard(primary: true, title: "ESTIMATED TIME", value: "\(route.duration.toHMS())", style: .time)
                    MetricsCard(primary: true, title: "DISTANCE", value: "\(route.distance) m", style: .distance)
                }
            }
        }
    }
    
    var buttons : some View{
        VStack{
            if let _ = route{
                ConnectButton(text: "Connect with CATRACA", onTap: {
                    nextView = true
                })
            }
        }
        .padding(.top,24)
    }
    
    func calculateDurationString() -> String? {
        guard let startDate = trip?.startDate, let endDate = trip?.endDate else {
            return nil
        }
        
        let interval = endDate.timeIntervalSince(startDate)
        
        let days = Int(interval) / 86400
        let hours = (Int(interval) % 86400) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60

        var components: [String] = []
        
        if days > 0 {
            components.append("\(String(format: "%02d", days))d")
        }
        if hours > 0 || days > 0 {
            components.append("\(String(format: "%02d", hours))h")
        }
        if minutes > 0 || hours > 0 || days > 0 {
            components.append("\(String(format: "%02d", minutes))m")
        }
        
        components.append("\(String(format: "%02d", seconds))s")
        
        return components.joined()
    }
    func formatEndDate() -> String? {
        guard let endDate = trip?.endDate else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current // Define o locale com base no local do usuário
        
        return formatter.string(from: endDate)
    }

}

#Preview {
    InformationsOfTripView(catracaIsConnected: false ,route:.constant(exempleOfRoute), trip: exempleOfTrip)
}
