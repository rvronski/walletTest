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


/*
 curl "https://api.m3o.com/v1/wallet/Create" \
 -H "Content-Type: application/json" \
 -H "Authorization: Bearer $M3O_API_TOKEN" \
 -d '{
   "description": "No explanation needed",
   "name": "Greatness"
 }
 
 
 "account": {
        "id": "b6407edd-2e26-45c0-9e2c-343689bbe5f6",
        "name": "Greatness",
        "description": "No description needed",
        "balance": "0"
    }
}
 */


//func resAPI(Login : String, Password : String) {
//
//    let request = NSMutableURLRequest(url: NSURL(string: "http:/index.php")! as URL)
//    request.httpMethod = "POST"
//
//    let myID = Picklist.init(code: Login, password: Password)
//    let encoder = JSONEncoder()
//
//    do {
//    let jsonData = try encoder.encode(myID)
//    request.httpBody = jsonData
//    print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
//    } catch {
//    print("ERROR")
//    }

struct Account: Codable {
    var id: String
    var name: String
    var description: String
    var balance: String
}

struct Answer: Codable {
    var account: Account
}

struct Param: Codable {
    var description: String
    var balance: String
}

func createWallet(description: String, balance: String ) {
    
    guard let url = URL(string: "https://api.m3o.com/v1/wallet/Create") else {return}
    
    let headers = [
        "Content-Type": "application/json",
        "Authorization": "Bearer NGEyNDRmZmEtZmQ0OS00MmU4LWE3MjAtZTMzZTI2ZTRkOGI4"
    ]
    
   
   
  
    let request = NSMutableURLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    let body = Param.init(description: description, balance: balance)
    let encoder = JSONEncoder()
    
    do {
        let jsonData = try encoder.encode(body)
        request.httpBody = jsonData
    } catch {
        print(error)
    }
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
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
       print(answer)
            
        } catch {
            print(error)
           
        }
    }
    task.resume()
    
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


