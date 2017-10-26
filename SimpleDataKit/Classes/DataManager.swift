//
//  DataManager.swift
//  SimpleDataKit
//
//  Created by Harley.xk on 2017/4/8.
//  Copyright (c) 2017 Harley. All rights reserved.
//
//

import CoreData

open class DataManager {
    
    open static var shared: DataManager {
        return sharedDataManager
    }
    
    // MARK: - CoreData
    open private(set) var context: NSManagedObjectContext!

    public typealias ContextSetupResult = (Error?) -> Void
    open func setupContext(with momdName: String = "Data", completion: ContextSetupResult? = nil) {
        if #available(iOS 10.0, *) {
            let container = NSPersistentContainer(name: momdName)
            container.loadPersistentStores { (_, error) in
                self.context = container.viewContext
                DispatchQueue.main.async {
                    completion?(error)
                }
            }
        } else {
            var errorInfo: Error?
            if let model = NSManagedObjectModel.mergedModel(from: nil) {
                let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                do {
                    let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0] as NSString
                    let storeURL = URL(fileURLWithPath: path.appendingPathComponent(momdName + ".momd"))
                    try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                } catch {
                    errorInfo = error
                }
                self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                self.context.persistentStoreCoordinator = coordinator
            } else {
                errorInfo = NSError(domain: "SimpleDataKit", code: -1, userInfo: ["message":"model not found"])
            }
            DispatchQueue.main.async {
                completion?(errorInfo)
            }
        }
    }
    
    @discardableResult open func save() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            #if DEBUG
                print("SimpleDataKit: Model saving failed: \(error.localizedDescription)")
            #endif
//            context.rollback()
            return false
        }
    }
    
    open func performChangeAndSave(closure: @escaping () -> Void) {
        context.perform {
            closure()
            self.save()
        }
    }
    
    // MARK: - Private
    private static let sharedDataManager = DataManager()
    private init() {}
}
