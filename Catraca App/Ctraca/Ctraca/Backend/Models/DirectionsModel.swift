//
//  Untitled.swift
//  Ctraca
//
//  Created by Wendell Borges on 15/02/25.
//

import SwiftUI
import Foundation
import CoreBluetooth
import Mapbox

import Foundation

struct DirectionsModel: Codable {
    let geocodedWaypoints: [GeocodedWaypoint]
    let routes: [Route]
    let status: String

    enum CodingKeys: String, CodingKey {
        case geocodedWaypoints = "geocoded_waypoints"
        case routes
        case status
    }
}

struct GeocodedWaypoint: Codable {
    let geocoderStatus: String
    let placeId: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case geocoderStatus = "geocoder_status"
        case placeId = "place_id"
        case types
    }
}

struct Route: Codable {
    let bounds: Bounds
    let copyrights: String
    let legs: [Leg]
    let overviewPolyline: OverviewPolyline
    let summary: String
    let warnings: [String]
    let waypointOrder: [Int]?

    enum CodingKeys: String, CodingKey {
        case bounds
        case copyrights
        case legs
        case overviewPolyline = "overview_polyline"
        case summary
        case warnings
        case waypointOrder = "waypoint_order"
    }
}

struct Bounds: Codable {
    let northeast: Location
    let southwest: Location
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}

struct Leg: Codable {
    let distance: Distance
    let duration: Duration
    let endAddress: String
    let endLocation: Location
    let startAddress: String
    let startLocation: Location
    let steps: [Step]
    let trafficSpeedEntry: [String]?
    let viaWaypoint: [String]?

    enum CodingKeys: String, CodingKey {
        case distance
        case duration
        case endAddress = "end_address"
        case endLocation = "end_location"
        case startAddress = "start_address"
        case startLocation = "start_location"
        case steps
        case trafficSpeedEntry = "traffic_speed_entry"
        case viaWaypoint = "via_waypoint"
    }
}

struct Distance: Codable {
    let text: String
    let value: Int
}

struct Duration: Codable {
    let text: String
    let value: Int
}

struct Step: Codable {
    let distance: Distance
    let duration: Duration
    let endLocation: Location
    let htmlInstructions: String
    let polyline: Polyline
    let startLocation: Location
    let travelMode: String
    let maneuver: String?

    enum CodingKeys: String, CodingKey {
        case distance
        case duration
        case endLocation = "end_location"
        case htmlInstructions = "html_instructions"
        case polyline
        case startLocation = "start_location"
        case travelMode = "travel_mode"
        case maneuver
    }
}

struct Polyline: Codable {
    let points: String
}

struct OverviewPolyline: Codable {
    let points: String
}

let exampleDirections = DirectionsModel(
    geocodedWaypoints: [
        GeocodedWaypoint(geocoderStatus: "OK", placeId: "ChIJ7cv00DwsDogRAMDACa2m4K8", types: ["street_address"])
    ],
    routes: [
        Route(
            bounds: Bounds(
                northeast: Location(lat: 34.1330949, lng: -118.321548),
                southwest: Location(lat: 33.8121, lng: -117.918984)
            ),
            copyrights: "Map data ©2025 Google",
            legs: [
                Leg(
                    distance: Distance(text: "42.8 km", value: 42800),
                    duration: Duration(text: "45 mins", value: 2700),
                    endAddress: "Universal Studios Hollywood, CA",
                    endLocation: Location(lat: 34.1381168, lng: -118.3533783),
                    startAddress: "Disneyland, CA",
                    startLocation: Location(lat: 33.8121, lng: -117.918984),
                    steps: [
                        Step(
                            distance: Distance(text: "1.2 km", value: 1200),
                            duration: Duration(text: "5 mins", value: 300),
                            endLocation: Location(lat: 33.8145, lng: -117.9243),
                            htmlInstructions: "Head north on Disneyland Dr",
                            polyline: Polyline(points: "a~l~Fjk~uOwHJy@P"),
                            startLocation: Location(lat: 33.8121, lng: -117.918984),
                            travelMode: "DRIVING",
                            maneuver: "turn-left"
                        )
                    ],
                    trafficSpeedEntry: nil,
                    viaWaypoint: nil
                )
            ],
            overviewPolyline: OverviewPolyline(points: "a~l~Fjk~uOwHJy@P"),
            summary: "I-5 N",
            warnings: [],
            waypointOrder: nil
        )
    ],
    status: "OK"
)


func fetchDirections(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, apiKey: String = ApiKey, completion: @escaping (Result<DirectionsModel, Error>) -> Void) {
    // Criar a URL formatada com coordenadas
    let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=bicycling&language=en&key=\(apiKey)"
    
    // Garantir que a URL seja válida
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "URL Inválida", code: -1, userInfo: nil)))
        return
    }
    
    // Criar a requisição
    let request = URLRequest(url: url)
    
    // Criar a tarefa de rede
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(NSError(domain: "Nenhum dado recebido", code: -2, userInfo: nil)))
            return
        }
        
        do {
            // Decodificar os dados em um objeto DirectionsModel
            let decoder = JSONDecoder()
            let directions = try decoder.decode(DirectionsModel.self, from: data)
            completion(.success(directions))
        } catch {
            completion(.failure(error))
        }
    }.resume() // Iniciar a requisição
}
