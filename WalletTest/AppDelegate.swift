//
//  AppDelegate.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 21.01.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let date = "2023-01-25T14:23:38.621132204Z"
//        let dateFormater = ISO8601DateFormatter()
//        dateFormater.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        guard let string = dateFormater.date(from: date) else { return false }
//        print(string)
        NetworkManager().transactions(id: "71a90f41-dcf2-4b28-9cb3-02b7468c05df") { trans in
            print(trans)
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

  
}

