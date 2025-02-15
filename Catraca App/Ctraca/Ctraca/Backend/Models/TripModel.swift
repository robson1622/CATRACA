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
    var average : Double
    var maxSpeed : Double
    var startLocal : String
    var endLocal : String
    var routePoints : [PointModel]
}


let exempleOfTrip = TripModel(startDate: Date(), endDate: Date(), distance: 2.3, average: 26, maxSpeed: 44.5, startLocal: "CEU", endLocal: "UTFPR",routePoints: [])
