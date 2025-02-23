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

struct DirectionsModel : Codable{
    
}


func fetchDirections(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, apiKey: String = ApiKey, completion: @escaping (Result<[String: Any], Error>) -> Void) {
    // Criar a URL formatada com coordenadas
    let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=bicycling&language=en&key=\(apiKey)"
    
    // Garantir que a URL seja válida
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "URL Inválida", code: -1, userInfo: nil)))
        return
    }
    print(urlString)
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
            // Tentar converter a resposta para um dicionário JSON
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                completion(.success(jsonResponse))
            } else {
                completion(.failure(NSError(domain: "Resposta inválida", code: -3, userInfo: nil)))
            }
        } catch {
            completion(.failure(error))
        }
    }.resume() // Iniciar a requisição
}
