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

struct NewWallet: Codable {
    var account: Account
}

struct NewWalletPost: Codable {
    var description: String = ""
    var name: String
}

struct Balance: Codable {
    var balance: String
}

struct DebitPost: Codable {
    var amount: String
    var id: String //"5e41b926-5bf6-45de-935c-9d0b39eab6ce"
    var reference: String // "test debit"
    var visible: Bool // true
}

struct CreditPost: Codable {
    var amount: String
    var id: String  //"5e41b926-5bf6-45de-935c-9d0b39eab6ce"
    var reference: String  = "test credit"
    var visible: Bool = true
}

struct TransferPost: Codable {
    var amount: String
    var from_id: String
    var reference: String
    var to_id: String
    var visible: Bool
    
}

class NetworkManager {
    
    enum Operations {
        case create
        case debit
        case credit
        case balance
        case transfer
    }
    
    let headers = [
        "Content-Type": "application/json",
        "Authorization": "Bearer NGEyNDRmZmEtZmQ0OS00MmU4LWE3MjAtZTMzZTI2ZTRkOGI4"
    ]
    
    func createWallet(name: String, completion: @escaping ((NewWallet) -> Void)) {
        
        guard let url = URL(string: "https://api.m3o.com/v1/wallet/Create") else {return}
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = self.headers
        let body = NewWalletPost.init(name: name)
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
                let answer = try JSONDecoder().decode(NewWallet.self, from: data)
                completion(answer)
                
            } catch {
                print(error)
                
            }
        }
        task.resume()
        
    }
    
    func debit() {
        
        guard let url = URL(string: "https://api.m3o.com/v1/wallet/Debit") else {return}
       
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = self.headers
        let body = DebitPost(amount: "10", id: "a3d9cf5f-1735-4757-842f-9a52d6132a4b", reference: "test debit", visible: true)
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
                let answer = try JSONDecoder().decode(Balance.self, from: data)
                
                print(answer)
                
            } catch {
                print(error)
                
            }
        }
        task.resume()
        
    }
    
    func credit(amount: String, id: String, completion: @escaping ((_ balance: String) -> Void)) {
        
        guard let url = URL(string: "https://api.m3o.com/v1/wallet/Credit") else {return}
       
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = self.headers
        let body = CreditPost.init(amount: amount, id: id)
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
                let answer = try JSONDecoder().decode(Balance.self, from: data)
                let balance = answer.balance
                completion(balance)
                
                
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
    
}
