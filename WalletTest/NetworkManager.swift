//
//  NetworkManager.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 22.01.2023.
//

import Foundation

/*
 {
     "card": "5923761798059986",
     "card_formatted": "5923 7617 9805 9986",
     "expiration_date": "09/23",
     "cvc": "786",
     "name": "Mastercard"
 }
 
 */

struct CardCodable: Codable {
    var card_formatted: String
    var expiration_date: String
    var cvc: String
}



func downloadCard(completion: @escaping ((CardCodable?) -> Void)) {
    
    guard let urlServer = URL(string: "https://api.generadordni.es/v2/bank/card" ) else {return}
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: urlServer) { data, response, error in
        if let error {
            print(error.localizedDescription)
            completion(nil)
            return
        }
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        print(statusCode ?? "")
        if statusCode != 200 {
            print("Status Code = \(String(describing: statusCode))")
            completion(nil)
            return
        }
        guard let data else {
            print("data = nil")
            completion(nil)
            return
        }
        do {
            let answer = try JSONDecoder().decode([CardCodable].self, from: data)
            let card = answer.first
            completion(card)
        } catch {
            print(error)
            completion(nil)
        }
    }
    task.resume()
}
