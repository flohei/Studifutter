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
    private let modelName = "Studifutter"
    
    var managedObjectModel: NSManagedObjectModel?
    var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    var managedObjectContext: NSManagedObjectContext?
    
    override init() {
        super.init()
        
        // Create the NSManagedObjectModel
        let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
        managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        createPersistentStoreCoordinator()
        createManagedObjectContext()
    }
    
    private func createPersistentStoreCoordinator() {
        // Create the NSPersistentStoreCoordinator
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel!)
        let fileName = "\(self.modelName).sqlite"
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(fileName)
        var error: NSError? = nil
        let failureReason = "There was an error creating or loading the application's saved data."
        let options = [NSMigratePersistentStoresAutomaticallyOption: NSNumber(bool: true),
            NSInferMappingModelAutomaticallyOption: NSNumber(bool: true)]
        
        do {
            try persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        } catch let error1 as NSError {
            error = error1
            persistentStoreCoordinator = nil
            // Report any error we got.
            let dict: [NSObject : AnyObject] = [
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
    
    private func createManagedObjectContext() {
        // Create the NSManagedObjectContext
        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext!.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.rootof.LocationAlert" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
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
    
    func managedObjectIDForURIRepresentation(url: NSURL) -> NSManagedObjectID {
        let objectID = self.persistentStoreCoordinator!.managedObjectIDForURIRepresentation(url)!
        return objectID
    }
    
    func managedObjectForID(identifier: String) -> NSManagedObject {
        var result: NSManagedObject?
        
        let idURL: NSURL = NSURL(string: identifier)!
        let objectID: NSManagedObjectID? = self.managedObjectIDForURIRepresentation(idURL)
        
        if let constObjectID = objectID {
            result = self.managedObjectContext?.objectWithID(constObjectID)
        }
        
        return result!
    }
    
    func clearStores() {
        let stores = persistentStoreCoordinator!.persistentStores
        
        for store in stores {
            var removeError: NSError? = nil
            let path = store.URL?.path
            
            do {
                try self.persistentStoreCoordinator?.removePersistentStore(store)
            } catch let error as NSError {
                removeError = error
            }
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path!)
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