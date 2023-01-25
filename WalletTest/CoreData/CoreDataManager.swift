//
//  CoreDataManager.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 22.01.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    init() {
        self.reloadUsers()
    }
    
    var users = [User]()
    var wallets = [Wallet]()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WalletTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func reloadUsers() {
        let request = User.fetchRequest()
        self.users = (try? persistentContainer.viewContext.fetch(request)) ?? []
       
    }
    
    func reloadWallets() {
        let request = Wallet.fetchRequest()
        self.wallets = (try? persistentContainer.viewContext.fetch(request)) ?? []
       
    }
    
    func createUser(email: String, password: String, userName: String, completion: @escaping () -> Void ) {
        persistentContainer.performBackgroundTask { backgroundContext in
            let user = User(context: backgroundContext)
            user.email = email
            user.password = password
            user.userName = userName
            do {
                try backgroundContext.save()
                self.reloadUsers()
            } catch {
                print(error)
            }
            completion()
        }
    }
    
    func createWallet(newWallet: NewWallet, user: User, completion: @escaping () -> Void ) {
        persistentContainer.performBackgroundTask { backgroundContext in
            let wallet = Wallet(context: backgroundContext)
            wallet.id = newWallet.account.id
            wallet.balance = newWallet.account.balance
            wallet.nameWallet = newWallet.account.name
            wallet.user = user
            wallet.createDate = Date()
            do {
                try backgroundContext.save()
                self.reloadUsers()
            } catch {
                print(error)
            }
            completion()
        }
    }
    
    func getUser(email: String, completion: (((User)?) -> Void) ) {
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        do {
            guard let user = try persistentContainer.viewContext.fetch(fetchRequest).first else {  return }
            completion(user)
        } catch {
            print(error)
            completion(nil)
        }
        
    }
    
    func changeBalance(id: String, newBalance: String, completion: @escaping () -> Void ) {
        let fetchRequest = Wallet.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let wallet = try persistentContainer.viewContext.fetch(fetchRequest).first
            wallet?.balance = newBalance
            saveContext()
            reloadUsers()
        }
        catch {
            print(error)
        }
        completion()
    }
    
    
//    func getWallets(email: String) {
//        let fetchRequest = User.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
//        
//        let user = try? persistentContainer.viewContext.fetch(fetchRequest).first
//        let wallets = user?.wallets
//        
//      
//    }
}
