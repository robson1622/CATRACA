//
//  TripModel.swift
//  Ctraca
//
//  Created by Robson Borges on 30/10/24.
//

import Foundation


struct TripModel : Codable{
    var id = UUID()
    var idOwner : UUID?
    var startDate : Date
    var endDate : Date
    var distance : Double
    var maxSpeed : Double
    var startLocal : LocationModel
    var endLocal : LocationModel
    var routePoints : [PointModel]
    
    func averageSpeed() -> Double{
        return distance / (endDate.timeIntervalSince(startDate) / 3600)
    }
    
    func toRoute() -> RouteModel{
        let duration = Int(endDate.timeIntervalSince(startDate))
        let route = RouteModel(id: self.id.uuidString, out: startLocal, finish: endLocal, date: startDate, listOfPoints: routePoints, distance: self.distance, duration: duration)
        
        return route
    }
}


let exempleOfTrip = TripModel(startDate: Date(), endDate: Date(), distance: 2.3, maxSpeed: 44.5, startLocal: exempleLocation, endLocal: exempleLocation,routePoints: [])
