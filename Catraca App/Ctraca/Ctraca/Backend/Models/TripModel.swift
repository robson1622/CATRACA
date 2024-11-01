//
//  TripModel.swift
//  Ctraca
//
//  Created by Robson Borges on 30/10/24.
//

import Foundation


struct TripModel : Hashable, Codable{
    var id = UUID()
    var startDate : Date
    var endDate : Date
    var distance : Double
    var average : Double
    var maxSpeed : Double
    var startLocal : String
    var endLocal : String
    
//    func getDuration() -> TimeInterval{
//        
//    }
}
