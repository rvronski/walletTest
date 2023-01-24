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
        self.reloadWallets()
    }
    
    var wallet = [Wallet]()
    
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
    
    func reloadWallets() {
        let request = Wallet.fetchRequest()
        self.wallet = (try? persistentContainer.viewContext.fetch(request)) ?? []
       
    }
    
    func createWallet(email: String, userName: String, password: String, nameWallet: String, newWallet: NewWallet, completion: @escaping () -> Void ) {
        persistentContainer.performBackgroundTask { backgroundContext in
            let wallet = Wallet(context: backgroundContext)
            wallet.userName = userName
            wallet.email = email
            wallet.id = newWallet.account.id
            wallet.password = password
            wallet.balance = newWallet.account.balance
            wallet.nameWallet = nameWallet
            
            do {
                try backgroundContext.save()
                self.reloadWallets()
            } catch {
                print(error)
            }
            completion()
        }
    }
    
}
