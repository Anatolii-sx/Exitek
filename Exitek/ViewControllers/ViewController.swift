//
//  ViewController.swift
//  Exitek
//
//  Created by Анатолий Миронов on 13.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let mobile = Mobile(imei: "4444", model: "iPhone10")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Save device
        do {
            try StorageManager.shared.save(mobile)
        } catch {
            print(error)
        }
        
        // Find by imei
        print("🕵️‍♀️ Founded device by imei:", StorageManager.shared.findByImei(mobile.imei) ?? "nil")
        // Exist
        print("👀 Device exists:", StorageManager.shared.exists(mobile))
        // All devices
        print("📘 All devices:", StorageManager.shared.getAll())
        
        // Delete device
        do {
            try StorageManager.shared.delete(mobile)
        } catch {
            print(error)
        }
    }
}

