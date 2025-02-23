//
//  LocalSaverController.swift
//  Ctraca
//
//  Created by Robson Borges on 13/11/24.
//

import Foundation

class LocalSaverController {
    private let key: String = "triplog" // A chave usada para salvar os dados no UserDefaults
    
    // Função para ler as viagens salvas
    func readTrips() -> [TripModel]? {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let trips = try JSONDecoder().decode([TripModel].self, from: data)
                return trips
            } catch {
                print("Erro ao decodificar trips: \(error)")
                return nil
            }
        }
        return nil
    }
    
    // Função para salvar uma nova viagem
    func saveTrip(trip: TripModel) {
        var trips = readTrips() ?? [] // Lê a lista existente ou cria uma nova
        trips.append(trip) // Adiciona a nova trip

        do {
            let data = try JSONEncoder().encode(trips)
            UserDefaults.standard.set(data, forKey: key) // Salva a lista atualizada no UserDefaults
        } catch {
            print("Erro ao codificar trips: \(error)")
        }
    }
}
