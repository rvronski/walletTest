//
//  NetworkManager.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 22.01.2023.
//

import Foundation
/*
 
 "id": 0 ,
 "userName": "Roman",
 "lastName": "Vronskiy",
 "cardNumber": 1234567898765432,
 "cvc": 234,
 "invalidDate": "02/25"

}
 
 {
   "userId": 1,
   "id": 1,
   "title": "delectus aut autem",
   "completed": false
 }
 
 
 
 "status": "OK",
 "code": 200,
 "total": 100,
 "data": [
 {
 "id": "f427fb6c-a945-3c03-b273-8d2b9b918e0b",
 "first_name": "Ted",
 "last_name": "Nikolaus",
 "birthday": "1977-03-16",
 "cardNumber": "4396054421113326",
 "cardType": "Visa"
 },

 */
//struct Answer: Codable {
//    var id: Int?
//    var userName: String?
//    var lastName: String?
//    var cardNumber: Int?
//    var cvc: Int?
//
//}

struct Test: Codable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
    
}

struct Datas: Codable {
    var id: String
    var first_name: String
    var last_name: String
    var birthday: String
    var cardNumber: String
    var cardType: String

}

struct Answer: Codable {
    var data: [Datas]
}

//https://github.com/rvronski/myServer/blob/main/db.json
func downloadUser() {
    
    guard let urlServer = URL(string: "https://fakerapi.it/api/v1/custom?_quantity=100&_locale=en_US&id=uuid&first_name=firstName&last_name=lastName&birthday=date&cardNumber=card_number&cardType=card_type" ) else {return}
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: urlServer) { data, response, error in
        if let error {
            print(error.localizedDescription)
            return
        }
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        print(statusCode ?? "")
        if statusCode != 200 {
            print("Status Code = \(String(describing: statusCode))")
            return
        }
        guard let data else {
            print("data = nil")
            return
        }
        do {
            let answer = try JSONDecoder().decode(Answer.self, from: data)
            print("🍓\(String(describing: answer.data.first))")
        } catch {
            print(error)
        }
    }
    task.resume()
}
