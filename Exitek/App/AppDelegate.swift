//
//  AppDelegate.swift
//  Exitek
//
//  Created by Анатолий Миронов on 13.09.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var isFirstLaunch: Bool {
        get {
            UserDefaults.standard.object(forKey: "isFirstLaunch") as? Bool ?? true
        } set {
            UserDefaults.standard.set(newValue, forKey: "isFirstLaunch")
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Save some devices when app opened first time
        if isFirstLaunch {
            Mobile.getSomeMobiles().forEach { mobile in
                do {
                    try StorageManager.shared.save(mobile)
                } catch {
                    print(error)
                }
            }
            isFirstLaunch = false
        }

        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        StorageManager.shared.saveContext()
    }
}

