//
//  CoreDataManager.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 22.01.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WalletTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
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
    
    var user = [User]()
    
    func addUser(name: String, lastName: String, cards: CardCodable, completion: @escaping () -> Void ) {
//        guard let card else { return }
        
        persistentContainer.performBackgroundTask { backgroundContext in
            let user = User(context: backgroundContext)
            let card = Card(context: backgroundContext)
            user.name = name
            user.lastName = lastName
            card.cardNumber = cards.card_formatted
            card.cardValidDate = cards.expiration_date
            card.cvc = cards.cvc
            card.userID = UUID()
            
            do {
                try backgroundContext.save()
            } catch {
                print(error)
            }
            completion()
        }
    }
    
}
