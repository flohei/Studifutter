//
//  FHCoreDataStack.m
//  Studifutter
//
//  Created by Florian Heiber on 26/09/14.
//  Copyright (c) 2014 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "FHCoreDataStack.h"

@implementation FHCoreDataStack

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

static FHCoreDataStack *_stack;

/**
 Returns a Connection object to proivde access to the API.
 */
+ (FHCoreDataStack *)sharedStack {
    @synchronized(self) {
        if (!_stack) {
            _stack = [[self alloc] init];
        }
    }
    
    return _stack;
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
        
        // create an undo manager
        NSUndoManager *undoManager = [[NSUndoManager alloc] init];
        [__managedObjectContext setUndoManager:undoManager];
        undoManager = nil;
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Studifutter" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *directoryURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.StudifutterContainer"];
    NSURL *storeURL = [directoryURL URLByAppendingPathComponent:@"Studifutter.sqlite"];
    
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setValue:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setValue:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

- (NSManagedObjectID *)managedObjectIDForURIRepresentation:(NSURL *)URL {
    return [self.persistentStoreCoordinator managedObjectIDForURIRepresentation:URL];
}

- (NSManagedObject *)managedObjectForID:(NSString *)ID {
    NSManagedObject *result = nil;
    
    @try {
        NSURL *IDURL = [NSURL URLWithString:ID];
        NSManagedObjectID *managedObjectID = [self managedObjectIDForURIRepresentation:IDURL];
        if (managedObjectID) {
            result = [self.managedObjectContext objectWithID:managedObjectID];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    
    return result;
}

#pragma mark -

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            
            // undo the last changes and notify the user
            [[[self managedObjectContext] undoManager] undo];
        }
    }
}

- (void)clearStores {
    NSArray *stores = [[self persistentStoreCoordinator] persistentStores];
    
    for (NSPersistentStore *store in stores) {
        NSError *deleteError = nil;
        NSError *removeError = nil;
        
        [[self persistentStoreCoordinator] removePersistentStore:store error:&removeError];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:&deleteError];
        
        NSAssert(removeError == nil, [removeError localizedDescription]);
        NSAssert(deleteError == nil, [deleteError localizedDescription]);
    }
    
    __managedObjectContext = nil;
    __managedObjectModel = nil;
    __persistentStoreCoordinator = nil;
}

@end
