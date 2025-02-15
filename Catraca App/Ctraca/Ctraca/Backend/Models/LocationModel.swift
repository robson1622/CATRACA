//
//  LocationModel.swift
//  Ctraca
//
//  Created by Robson Borges on 09/11/24.
//

import Foundation
import MapKit

struct LocationModel : Codable{
    var local : String
    var position : PointModel?
    
    init(local: String, position: PointModel? = nil) {
        self.local = local
        self.position = position
    }
    init(local: String, position: CLLocationCoordinate2D) {
        self.local = local
        self.position = PointModel(latitude: position.latitude, longitude: position.longitude)
    }
}

struct PointModel : Codable{
    var latitude : Double
    var longitude : Double
    
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    init(latitude : Double,longitude : Double)  {
        self.latitude = latitude
        self.longitude = longitude
    }
    init(position : CLLocationCoordinate2D)  {
        self.latitude = position.latitude
        self.longitude = position.longitude
    }
}

let exempleLocation = LocationModel(local: "Home of carai")
