//
//  StorageManager.swift
//  Exitek
//
//  Created by Анатолий Миронов on 13.09.2022.
//

import CoreData
import Foundation

enum StorageErrors: Error {
    case saveError
    case deleteError
}

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}

final class StorageManager {
   static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Exitek")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    func fetchData() -> [Device]  {
        let fetchRequest = Device.fetchRequest()
        do {
            let devices = try viewContext.fetch(fetchRequest)
              return devices
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension StorageManager: MobileStorage {
    func getAll() -> Set<Mobile> {
        let devices = fetchData()
        var mobiles: Set<Mobile> = []
        
        devices.forEach { device in
            if let imei = device.imei, let model = device.model {
                mobiles.insert(Mobile(imei: imei, model: model))
            }
        }
        
        return mobiles
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        let mobiles = getAll()
        var foundedMobile: Mobile?
        mobiles.forEach { mobile in
            if mobile.imei == imei {
                foundedMobile = mobile
            }
        }
        return foundedMobile
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        if !exists(mobile) {
            if let entity = NSEntityDescription.entity(forEntityName: "Device", in: viewContext),
               let device = NSManagedObject(entity: entity, insertInto: viewContext) as? Device {
                device.imei = mobile.imei
                device.model = mobile.model
                saveContext()
                print("✅ Device saved:", mobile)
            }
        } else if mobile.imei.isEmpty {
            print("⛔️ Saved error: mobile imei is empty")
            throw StorageErrors.saveError
        } else {
            print("⛔️ Device \(mobile) is already in Core Data")
            throw StorageErrors.saveError
        }
        return mobile
    }
    
    func delete(_ product: Mobile) throws {
        let devices = fetchData()
        var deviceDeleted = false
        devices.forEach { device in
            if device.imei == product.imei {
                deviceDeleted = true
                viewContext.delete(device)
                saveContext()
            }
        }
        if !deviceDeleted {
            print("⛔️ Delete error, device wasn't founded")
            throw StorageErrors.deleteError
        }
    }
    
    func exists(_ product: Mobile) -> Bool {
        let devices = fetchData()
        var status = false
        devices.forEach { status = $0.imei == product.imei ? true : false }
        return status
    }
}
