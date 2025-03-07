//
//  RouteModel.swift
//  Ctraca
//
//  Created by Robson Borges on 12/11/24.
//
import SwiftUI
import Foundation
import CoreBluetooth
import Mapbox

struct RouteModel : Codable{
    var id: String
    var out : LocationModel
    var finish : LocationModel
    var date : Date
    var listOfPoints : [PointModel]
    var distance : Double // distancia em metros
    var duration : Int // duração em segundos
    

    // Helper to decode polyline
    private func decodePolyline(_ encoded: String) -> [CLLocationCoordinate2D] {
        var coords: [CLLocationCoordinate2D] = []
        var latitude = 0
        var longitude = 0
        var index = encoded.startIndex
        while index < encoded.endIndex {
            var b: Int
            var shift = 0
            var result = 0
            repeat {
                b = Int(encoded[index].asciiValue! - 63)
                index = encoded.index(after: index)
                result |= (b & 0x1F) << shift
                shift += 5
            } while b >= 0x20
            let deltaLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1))
            latitude += deltaLat

            shift = 0
            result = 0
            repeat {
                b = Int(encoded[index].asciiValue! - 63)
                index = encoded.index(after: index)
                result |= (b & 0x1F) << shift
                shift += 5
            } while b >= 0x20
            let deltaLon = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1))
            longitude += deltaLon

            let coord = CLLocationCoordinate2D(latitude: Double(latitude) / 1E5, longitude: Double(longitude) / 1E5)
            coords.append(coord)
        }
        return coords
    }

    func forJSON() -> [String: Any] {
        let points: [[String: Double]] = listOfPoints.map { point in
           ["latitude": point.latitude, "longitude": point.longitude]
        }
       
        let jsonData: [String: Any] = [
            "type" : "Route",
            "id": id,
            "out": out,
            "finish": finish,
            "distance": distance,
            "duration": duration,
            "listOfPoints": points
        ]
        
        return jsonData
    }
    

}

// Função para calcular a distância entre dois pontos usando a fórmula de Haversine
func haversineDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
    let earthRadius = 6371000.0 // Raio da Terra em metros

    let lat1 = from.latitude.degreesToRadians
    let lon1 = from.longitude.degreesToRadians
    let lat2 = to.latitude.degreesToRadians
    let lon2 = to.longitude.degreesToRadians

    let dLat = lat2 - lat1
    let dLon = lon2 - lon1

    let a = sin(dLat / 2) * sin(dLat / 2) +
            cos(lat1) * cos(lat2) *
            sin(dLon / 2) * sin(dLon / 2)

    let c = 2 * atan2(sqrt(a), sqrt(1 - a))

    return earthRadius * c
}

func calculateTotalDistance(points : [PointModel]) -> Double {
    var totalDistance: Double = 0.0
    if points.count >= 1{
        for i in 0..<(points.count - 1) {
            let currentPoint = points[i]
            let nextPoint = points[i + 1]
            
            let currentLocation = CLLocationCoordinate2D(latitude: currentPoint.latitude, longitude: currentPoint.longitude)
            let nextLocation = CLLocationCoordinate2D(latitude: nextPoint.latitude, longitude: nextPoint.longitude)
            
            let distance = haversineDistance(from: currentLocation, to: nextLocation)
            totalDistance += distance
        }
    }
    return totalDistance
}


let exempleOfRoute = RouteModel(id: "1",  out: exempleLocation, finish: exempleLocation, date: Date(), listOfPoints: [],distance: 1252.3,duration: 123456)


func fetchGoogleRoutes(apiKey: String = ApiKey,
                       origin: CLLocationCoordinate2D,
                       destination: CLLocationCoordinate2D,
                       completion: @escaping (Result<[CLLocationCoordinate2D], Error>) -> Void) {
    let urlString = "https://routes.googleapis.com/directions/v2:computeRoutes"
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
        return
    }

    struct RouteRequest: Codable {
        struct Location: Codable {
            let location: LatLng
        }
        struct LatLng: Codable {
            let latLng: Coordinates
        }
        struct Coordinates: Codable {
            let latitude: Double
            let longitude: Double
        }
        struct RouteModifiers: Codable {
            let avoidTolls: Bool
            let avoidHighways: Bool
            let avoidFerries: Bool
        }

        let origin: Location
        let destination: Location
        let travelMode: String
        var routingPreference: String?
        let computeAlternativeRoutes: Bool
        let routeModifiers: RouteModifiers
        let languageCode: String
        let units: String
    }

    struct RouteResponse: Codable {
        struct Route: Codable {
            let polyline: EncodedPolyline
        }
        struct EncodedPolyline: Codable {
            let encodedPolyline: String
        }

        let routes: [Route]
    }

    let requestPayload = RouteRequest(
        origin: .init(location: .init(latLng: .init(latitude: origin.latitude, longitude: origin.longitude))),
        destination: .init(location: .init(latLng: .init(latitude: destination.latitude, longitude: destination.longitude))),
        travelMode: "BICYCLE", // Modo bicicleta
        computeAlternativeRoutes: false,
        routeModifiers: .init(
            avoidTolls: false,
            avoidHighways: false, // Este parâmetro será ignorado
            avoidFerries: false
        ),
        languageCode: "en-US",
        units: "METRIC"
    )


    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(apiKey, forHTTPHeaderField: "X-Goog-Api-Key")
    request.setValue("routes.polyline.encodedPolyline", forHTTPHeaderField: "X-Goog-FieldMask")

    do {
        let jsonData = try JSONEncoder().encode(requestPayload)
        request.httpBody = jsonData
    } catch {
        completion(.failure(error))
        return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
            return
        }
        // Depuração da resposta do servidor
        do {
            let decodedResponse = try JSONDecoder().decode(RouteResponse.self, from: data)

            guard let encodedPolyline = decodedResponse.routes.first?.polyline.encodedPolyline else {
                completion(.failure(NSError(domain: "No polyline found in response", code: -1, userInfo: nil)))
                return
            }

            let coordinates = decodePolyline(encodedPolyline)
            completion(.success(coordinates))
        } catch {
            print("Erro ao decodificar JSON: \(error)")
            completion(.failure(error))
        }
    }.resume()

}

func decodePolyline(_ polyline: String) -> [CLLocationCoordinate2D] {
    var coordinates: [CLLocationCoordinate2D] = []
    var index = polyline.startIndex
    let end = polyline.endIndex

    var latitude: Int32 = 0
    var longitude: Int32 = 0

    while index < end {
        var result: Int32 = 0
        var shift: Int32 = 0
        var byte: Int32

        repeat {
            byte = Int32(polyline[index].asciiValue!) - 63
            index = polyline.index(after: index)
            result |= (byte & 0x1F) << shift
            shift += 5
        } while byte >= 0x20

        let deltaLatitude = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1))
        latitude += deltaLatitude

        result = 0
        shift = 0

        repeat {
            byte = Int32(polyline[index].asciiValue!) - 63
            index = polyline.index(after: index)
            result |= (byte & 0x1F) << shift
            shift += 5
        } while byte >= 0x20

        let deltaLongitude = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1))
        longitude += deltaLongitude

        let finalLatitude = Double(latitude) * 1e-5
        let finalLongitude = Double(longitude) * 1e-5

        coordinates.append(CLLocationCoordinate2D(latitude: finalLatitude, longitude: finalLongitude))
    }

    return coordinates
}

// Extensão para converter graus em radianos
extension Double {
    var degreesToRadians: Double {
        return self * .pi / 180
    }
}
