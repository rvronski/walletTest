//
//  NetworkManager.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 22.01.2023.
//

import Foundation


struct TransactionCodable: Codable {
    var id: String
    var created: String
    var amount: String
    var reference: String
}

struct TransAnswer: Codable {
    var transactions: [TransactionCodable]
}

struct TransactionPost: Codable {
    var id: String
}

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
    var description: String = "Новый счет"
    var name: String
}

struct Balance: Codable {
    var balance: String
}

struct DebitPost: Codable {
    var amount: String
    var id: String
    var reference: String
    var visible: Bool = true
}

struct CreditPost: Codable {
    var amount: String
    var id: String
    var reference: String  = "Пополнение"
    var visible: Bool = true
}

struct TransferPost: Codable {
    var amount: String
    var from_id: String
    var reference: String
    var to_id: String
    var visible: Bool = true
    
}

struct Delete: Codable {
    var id: String
}

class NetworkManager {
    
    static let shared: NetworkManager = .init()
    
    let headers = [
        "Content-Type": "application/json",
        "Authorization": "Bearer NGEyNDRmZmEtZmQ0OS00MmU4LWE3MjAtZTMzZTI2ZTRkOGI4"
    ]
    
    
    func transactions(id: String, completion: @escaping ([TransactionCodable]) -> Void) {
        
        guard let url = URL(string: "https://api.m3o.com/v1/wallet/Transactions") else {return}
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = self.headers
        let body = TransactionPost.init(id: id)
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
                let answer = try JSONDecoder().decode(TransAnswer.self, from: data)
                let transactions = answer.transactions
                completion(transactions)
                
            } catch {
                print(error)
                
            }
        }
        task.resume()
        
    }
    
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
    
    func debit(amount: String, id: String, reference: String, completion: @escaping ((_ balance: String) -> Void) ) {
        
        guard let url = URL(string: "https://api.m3o.com/v1/wallet/Debit") else {return}
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = self.headers
        let body = DebitPost(amount: amount, id: id, reference: reference)
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
    
    func credit(amount: String, id: String, completion: @escaping ((_ balance: String) -> Void))  {
        
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
    
    func transfer(amount: String, from_id: String, to_id: String, completion: @escaping () -> Void )  {
        
        guard let url = URL(string: "https://api.m3o.com/v1/wallet/Transfer") else {return}
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = self.headers
        let body = TransferPost.init(amount: amount, from_id: from_id, reference: "перевод между счетами", to_id: to_id)
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
            guard data != nil else {
                print("data = nil")
                return
            }
            completion()
        }
        task.resume()
        
    }
    
    func deleteWallet(id: String, completion: @escaping () -> Void )  {
        
        guard let url = URL(string: "https://api.m3o.com/v1/wallet/Delete") else {return}
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = self.headers
        let body = Delete.init(id: id)
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
            guard data != nil else {
                print("data = nil")
                return
            }
            completion()
        }
        task.resume()
    }
}
