//
//  FirebaseController.swift
//  Ctraca
//
//  Created by Robson Borges on 11/01/25.
//

import Foundation
import FirebaseFirestore

class FirebaseController {
    static let shared = FirebaseController()
    
    private let db = Firestore.firestore()
    
    private let tableUser = "user"
    private let tableTrip = "trip"
    
    // criar
    func create<T: Encodable>(model: T) -> String? {
        do {
            let document = try db.collection(tableTrip).addDocument(from: model)
            return document.documentID
        } catch {
            print("Erro ao adicionar o documento: \(error)")
        }
        return nil
    }
    // query por id
    func readDocuments<T : Decodable>(isEqualValue: String, field : String) async -> [T]{
        do {
            let querySnapshot = try await db.collection(tableTrip).whereField(field, isEqualTo: isEqualValue).getDocuments()
            var retorno : [T] = []
            for doc in querySnapshot.documents {
                retorno.append(try doc.data(as: T.self))
            }
            return retorno
            
        }
        catch {
            print(error)
            return []
        }
    }
}
