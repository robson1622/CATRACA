//
//  Extenssions.swift
//  Ctraca
//
//  Created by Robson Borges on 27/11/24.
//

import Foundation
import MapKit


extension CLLocationDegrees {
    func rounded(toPlaces places: Int) -> CLLocationDegrees {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double{
func toKilometers() -> Double{
    return self / 1000
}
}

extension Int{
func toHMS() -> String {
    let hours = self / 3600
    let minutes = (self % 3600) / 60
    let seconds = self % 60
    return "\(hours)h\(minutes)m\(seconds)s"
}
}
