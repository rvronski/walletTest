//
//  CoreDataManager.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 22.01.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared: CoreDataManager = .init()
    
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
    
    func createUser(email: String, password: String, userName: String, completion: @escaping () -> Void ) {
        persistentContainer.performBackgroundTask { backgroundContext in
            let user = User(context: backgroundContext)
            user.email = email
            user.password = password
            user.userName = userName
            do {
                try backgroundContext.save()
            } catch {
                print(error)
            }
            completion()
        }
    }
    
    func createWallet(newWallet: NewWallet, user: User, completion: @escaping () -> Void ) {
        
        let wallet = Wallet(context: persistentContainer.viewContext)
        wallet.id = newWallet.account.id
        wallet.balance = newWallet.account.balance
        wallet.nameWallet = newWallet.account.name
        user.addToWallets(wallet)
        wallet.createDate = Date()
        saveContext()
        completion()
    }
    
    func createTransactions(transactions: [TransactionCodable], wallet: Wallet, completion: @escaping () -> Void ) {
            for transaction in transactions {
                if self.getTransaction(byId: transaction.id, context: persistentContainer.viewContext) != nil { continue }
                let newTransaction = Transaction(context: persistentContainer.viewContext)
                let stringDate = transaction.created
                let dateFormater = ISO8601DateFormatter()
                dateFormater.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                guard let date = dateFormater.date(from: stringDate) else { return }
                let formatter = DateFormatter()
                formatter.dateFormat = "d MMM,YYYY"
                let dateString = formatter.string(from: date)
                newTransaction.id = transaction.id
                newTransaction.amount = transaction.amount
                newTransaction.created = date
                newTransaction.reference = transaction.reference
                newTransaction.stringDate = dateString
                wallet.addToTransactions(newTransaction)
                saveContext()
                completion()
            }
        }
    
    
    func getTransaction(byId: String, context: NSManagedObjectContext) -> Transaction? {
        let fetchRequest = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", byId)
        return (try? context.fetch(fetchRequest))?.first
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
        }
        catch {
            print(error)
        }
        completion()
    }
    
    func wallets(user: User) -> [Wallet] {
      let request: NSFetchRequest<Wallet> = Wallet.fetchRequest()
      request.predicate = NSPredicate(format: "user = %@", user)
      request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: true)]
      var fetchedWallets: [Wallet] = []
      do {
          fetchedWallets = try persistentContainer.viewContext.fetch(request)
      } catch let error {
        print("Error fetching songs \(error)")
      }
      return fetchedWallets
    }
    
    func transaction(wallet: Wallet) -> [Transaction] {
      let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
      request.predicate = NSPredicate(format: "wallet = %@", wallet)
      request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true)]
      var fetchedTransactions: [Transaction] = []
      do {
          fetchedTransactions = try persistentContainer.viewContext.fetch(request)
      } catch let error {
        print("Error fetching songs \(error)")
      }
      return fetchedTransactions
    }
    
    func user() -> [User] {
      let request: NSFetchRequest<User> = User.fetchRequest()
      var fetchedUsers: [User] = []
      do {
          fetchedUsers = try persistentContainer.viewContext.fetch(request)
      } catch let error {
         print("Error fetching singers \(error)")
      }
      return fetchedUsers
    }
    
    func deleteWallet(wallet: Wallet) {
        persistentContainer.viewContext.delete(wallet)
        saveContext()
    }
    
    func deleteUser(user: User) {
        persistentContainer.viewContext.delete(user)
        saveContext()
    }
    
}
