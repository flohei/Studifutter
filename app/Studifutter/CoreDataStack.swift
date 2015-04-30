//
//  CoreDataStack.swift
//
//  Created by Florian Heiber on 09.02.15.
//  Copyright (c) 2015 rootof.net. All rights reserved.
//

import Foundation
import CoreData

@objc class CoreDataStack {
    // Configure the model name here. This is the only setting you generally need to change.
    private let modelName = "Studifutter"
    
    class var sharedInstance: CoreDataStack {
        struct Static {
            static var instance: CoreDataStack?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = CoreDataStack()
        }
        
        return Static.instance!
    }
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.rootof.LocationAlert" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let fileName = "\(self.modelName).sqlite"
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(fileName)
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        let options = [NSMigratePersistentStoresAutomaticallyOption: NSNumber(bool: true),
            NSInferMappingModelAutomaticallyOption: NSNumber(bool: true)]
        
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
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
        var objectID: NSManagedObjectID? = self.managedObjectIDForURIRepresentation(idURL)
        
        if let constObjectID = objectID {
            result = self.managedObjectContext?.objectWithID(constObjectID)
        }
        
        return result!
    }
    
    func clearStores() {
        var stores: [NSPersistentStore] = self.persistentStoreCoordinator?.persistentStores as! [NSPersistentStore]
        
        for store in stores {
            var deleteError: NSError?
            var removeError: NSError?
            var path = store.URL?.path
            
            self.persistentStoreCoordinator?.removePersistentStore(store, error: &removeError)
            NSFileManager.defaultManager().removeItemAtPath(path!, error: &removeError)
            
            // Handle the errors here, if any
        }
    }
}