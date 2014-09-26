//
//  FHCoreDataStack.h
//  Studifutter
//
//  Created by Florian Heiber on 26/09/14.
//  Copyright (c) 2014 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FHCoreDataStack : NSObject

+ (FHCoreDataStack *)sharedStack;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSManagedObjectID *)managedObjectIDForURIRepresentation:(NSURL *)URL;
- (NSManagedObject *)managedObjectForID:(NSString *)ID;

- (void)saveContext;
- (void)clearStores;

@end
