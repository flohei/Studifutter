//
//  SFAppDelegate.m
//  Studifutter
//
//  Created by Florian Heiber on 29.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFAppDelegate.h"
#import "SFRestaurantViewController.h"
#import "SFDayListViewController.h"
#import "Connection.h"
#import "TestFlight.h"
#import "Restaurant.h"
#import "MenuSet.h"
#import "FHVersionUpdate.h"

@interface SFAppDelegate ()

- (void)cleanupLocalMenus;
- (void)downloadRestaurants;
- (void)clearStores;

@end

@implementation SFAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize operationBalance = _operationBalance;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Register for the use of TestFlight
    [TestFlight takeOff:TESTFLIGHT_TEAM_TOKEN];
    
    // check and handle update if neccessary
    [FHVersionUpdate checkAndHandleUpdate];
    
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    SFRestaurantViewController *controller = (SFRestaurantViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    
    // create one of these fancy new UUIDs if needed
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UUID_KEY]) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        NSString *uuidString = (__bridge NSString *)CFUUIDCreateString(NULL, uuid);
        //NSLog(@"Created new custom UUID: %@", uuidString);
        [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:UUID_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        CFRelease(uuid);
    }
    
    self.operationBalance = 0;
    [self cleanupLocalMenus];
    [self downloadRestaurants];
    
    // check if there's a last restaurant saved. if so push it.
    Restaurant *lastRestaurant = (Restaurant *)[self managedObjectForID:[[NSUserDefaults standardUserDefaults] objectForKey:LAST_OPENED_RESTAURANT_ID]];
    if (lastRestaurant) {
        SFDayListViewController *dayListViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"DayListViewController"];
        [dayListViewController setRestaurant:lastRestaurant];
        [navigationController pushViewController:dayListViewController animated:NO];
    }
    
    [TestFlight passCheckpoint:APP_START_CHECKPOINT];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Custom Code

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

- (void)refreshLocalData {
    [self cleanupLocalMenus];
    [self downloadRestaurants];
}

- (void)cleanupLocalMenus {
    if (self.localRestaurants) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        [calendar setTimeZone:timeZone];
        
        NSDate *today = [NSDate date];
        NSDateComponents *todaysComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
        
        //[todaysComponents setDay:[todaysComponents day] - 1];        
        NSDate *yesterday = [calendar dateFromComponents:todaysComponents];
        
        for (Restaurant *r in self.localRestaurants) {            
            for (MenuSet *ms in r.menuSet) {
                NSDate *menuSetDate = [ms date];
                if (menuSetDate == [menuSetDate earlierDate:yesterday]) {
                    [[self managedObjectContext] deleteObject:ms];
                }
            }
            
            [self saveContext];
        }
    }
}

- (NSArray *)localRestaurants {    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Restaurant" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:[self managedObjectContext] 
                                          sectionNameKeyPath:nil 
                                                   cacheName:@"Restaurant"];
    
    NSError *error;
	if (![theFetchedResultsController performFetch:&error]) {
		// Update to handle the error appropriately.
		//NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    NSArray *fetchedObjects = [theFetchedResultsController fetchedObjects];
    if (!fetchedObjects || [fetchedObjects count] == 0) {
        return nil;
    } else {
        return fetchedObjects;
    }
}

- (void)completeCleanup {
    [self clearStores];
    [self downloadRestaurants];
}

- (void)clearStores {
    NSArray *stores = [[self persistentStoreCoordinator] persistentStores];
    
    for (NSPersistentStore *store in stores) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:&error];
        
        NSAssert(error == nil, [error localizedDescription]);
    }
    
    __managedObjectContext = nil;
    __managedObjectModel = nil;
    __persistentStoreCoordinator = nil;
}

#pragma mark Operation Balance

- (int)operationBalance {
    return _operationBalance;
}

- (void)setOperationBalance:(int)operationBalance {
    _operationBalance = operationBalance;
    
    if (operationBalance > 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

#pragma mark Download

- (void)downloadRestaurants {
    NSInvocationOperation *downloadRestaurants = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(doDownloadRestaurants) object:nil];
    [[[Connection sharedConnection] sharedOperationQueue] addOperation:downloadRestaurants];
    self.operationBalance += 1;
}

- (void)doDownloadRestaurants {
    // call the API here
    BOOL success = [[Connection sharedConnection] readRestaurants];
    [self performSelectorOnMainThread:@selector(finishedDownloadRestaurants:) withObject:[NSNumber numberWithBool:success] waitUntilDone:YES];
}

- (void)finishedDownloadRestaurants:(BOOL)success {
    // get the restaurants here and fetch all the menus for each restaurant
    self.operationBalance -= 1;
    
    if (success) {
        [NSNotificationCenter.defaultCenter postNotification:[NSNotification notificationWithName:RESTAURANTS_UPDATED_NOTIFICATION object:nil]];
    }
}

- (void)downloadMenuForRestaurant:(Restaurant *)restaurant {
    [self performSelectorInBackground:@selector(doDownloadMenuForRestaurant:) withObject:restaurant];
}

- (void)doDownloadMenuForRestaurant:(Restaurant *)restaurant {
    BOOL success = NO;
    
    @try {
        if ([[Connection sharedConnection] readMenuForRestaurant:restaurant]) {
            success = YES;
        }
    }
    @catch (NSException *exception) {
        // notify the user
        [self performSelectorOnMainThread:@selector(raiseAlertOnMainThread) withObject:nil waitUntilDone:YES];
    }
    
    [self performSelectorOnMainThread:@selector(finishedDownloadMenusForRestaurant:) withObject:[NSNumber numberWithBool:success] waitUntilDone:YES];
}

- (void)finishedDownloadMenusForRestaurant:(BOOL)success {
    [NSNotificationCenter.defaultCenter postNotification:[NSNotification notificationWithName:MENUS_UPDATED_NOTIFICATION object:nil]];
}

- (void)raiseAlertOnMainThread {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hoppla..."
                                                      message:@"Da ist etwas schiefgelaufen, sorry. Probier's später bitte noch einmal."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
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
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Studifutter.sqlite"];
    
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

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
