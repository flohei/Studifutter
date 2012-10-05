//
//  SFAppDelegate.h
//  Studifutter
//
//  Created by Florian Heiber on 29.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)refreshLocalData;

- (void)completeCleanup;

@property int operationBalance;

- (NSArray *)localRestaurants;

- (NSManagedObjectID *)managedObjectIDForURIRepresentation:(NSURL *)URL;
- (NSManagedObject *)managedObjectForID:(NSString *)ID;

@end
