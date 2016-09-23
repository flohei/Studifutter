//
//  CoreDataStack.swift
//
//  Created by Florian Heiber on 09.02.15.
//  Copyright (c) 2015 rootof.net. All rights reserved.
//

import Foundation
import CoreData

@objc class CoreDataStack : NSObject {
    // Configure the model name here. This is the only setting you generally need to change.
    fileprivate let modelName = "Studifutter"
    
    var managedObjectModel: NSManagedObjectModel?
    var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    var managedObjectContext: NSManagedObjectContext?
    
    override init() {
        super.init()
        
        // Create the NSManagedObjectModel
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        
        createPersistentStoreCoordinator()
        createManagedObjectContext()
    }
    
    fileprivate func createPersistentStoreCoordinator() {
        // Create the NSPersistentStoreCoordinator
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel!)
        let fileName = "\(self.modelName).sqlite"
        let url = self.applicationDocumentsDirectory.appendingPathComponent(fileName)
        var error: NSError? = nil
        let failureReason = "There was an error creating or loading the application's saved data."
        let options = [NSMigratePersistentStoresAutomaticallyOption: NSNumber(value: true as Bool),
            NSInferMappingModelAutomaticallyOption: NSNumber(value: true as Bool)]
        
        do {
            try persistentStoreCoordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch let error1 as NSError {
            error = error1
            persistentStoreCoordinator = nil
            // Report any error we got.
            let dict: [AnyHashable: Any] = [
                NSLocalizedDescriptionKey: "Failed to initialize the application's saved data",
                NSLocalizedFailureReasonErrorKey: failureReason,
                NSUnderlyingErrorKey: error!]
            
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
    }
    
    fileprivate func createManagedObjectContext() {
        // Create the NSManagedObjectContext
        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext!.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    fileprivate lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.rootof.LocationAlert" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] 
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        guard let moc = self.managedObjectContext else {
            return
        }
        
        var error: NSError? = nil
        if moc.hasChanges {
            do {
                try moc.save()
            } catch let caughtError as NSError {
                error = caughtError
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: - Misc
    
    func managedObjectIDForURIRepresentation(_ url: URL) -> NSManagedObjectID {
        let objectID = self.persistentStoreCoordinator!.managedObjectID(forURIRepresentation: url)!
        return objectID
    }
    
    func managedObjectForID(_ identifier: String) -> NSManagedObject {
        var result: NSManagedObject?
        
        let idURL: URL = URL(string: identifier)!
        let objectID: NSManagedObjectID? = self.managedObjectIDForURIRepresentation(idURL)
        
        if let constObjectID = objectID {
            result = self.managedObjectContext?.object(with: constObjectID)
        }
        
        return result!
    }
    
    func clearStores() {
        let stores = persistentStoreCoordinator!.persistentStores
        
        for store in stores {
            var removeError: NSError? = nil
            let path = store.url?.path
            
            do {
                try self.persistentStoreCoordinator?.remove(store)
            } catch let error as NSError {
                removeError = error
            }
            
            do {
                try FileManager.default.removeItem(atPath: path!)
            } catch let error as NSError {
                removeError = error
            }
            
            // Handle the errors here, if any
            print(removeError?.localizedDescription)
        }
        
        persistentStoreCoordinator = nil
        createPersistentStoreCoordinator()
        createManagedObjectContext()
    }
}
