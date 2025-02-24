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
    func toHourAndMinuteString() -> String{
        let intPart = Int(self)
        let doublePart = self - Double(intPart)
        let minutePart = Int(doublePart * 60)
        return String(format: "%02dh%02dm", intPart, minutePart)
    }
}

extension Date{
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
    func difference(_ otherDate: Date) -> Int {
        let difference = self.timeIntervalSince(otherDate)
        return Int(difference / 60) // Converte segundos para minutos
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
