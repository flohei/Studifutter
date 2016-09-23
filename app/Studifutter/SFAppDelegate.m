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
#import "Restaurant.h"
#import "MenuSet.h"
#import "FHVersionUpdate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Studifutter-Swift.h"

@interface SFAppDelegate ()

- (void)cleanupLocalMenus;
- (void)downloadRestaurants;

@end

@implementation SFAppDelegate

@synthesize window = _window;
@synthesize coreDataStack = _coreDataStack;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // register for Crashlytics
    [Fabric with:@[[Crashlytics class]]];
    
    // setup appearance changes
    [self setupAppearance];
    
    // make sure we have a core data stack
    _coreDataStack = [CoreDataStack new];
    
    // create one of these fancy new UUIDs if needed
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UUID_KEY]) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        NSString *uuidString = (__bridge NSString *)CFUUIDCreateString(NULL, uuid);
        [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:UUID_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        CFRelease(uuid);
    }
    
    // check and handle update if neccessary
    [FHVersionUpdate checkAndHandleUpdate];
    
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
    // check if there's a last restaurant saved. if so push it.
    @try {
        NSString *lastRestaurantKey = [[[NSUserDefaults alloc] initWithSuiteName:@"group.StudifutterContainer"] objectForKey:LAST_OPENED_RESTAURANT_ID];
        if (lastRestaurantKey) {
            Restaurant *lastRestaurant = (Restaurant *)[self.coreDataStack managedObjectForID:lastRestaurantKey];
            if (lastRestaurant) {
                SFDayListViewController *dayListViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"DayListViewController"];
                [dayListViewController setRestaurant:lastRestaurant];
                [navigationController pushViewController:dayListViewController animated:NO];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error finding object: %@: %@", [exception name], [exception reason]);
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // check for new restaurants and delete old menu sets
    [self refreshLocalData];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    [self.coreDataStack saveContext];
}

#pragma mark - Custom Code

- (void)setupAppearance {
    // Set the overall UINavigationBar's tint color to the Studifutter red. This mimics the iOS 7
    // style of Notes.app etc.
    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
}

- (void)refreshLocalData {
    [self cleanupLocalMenus];
    [self downloadRestaurants];
}

- (void)completeCleanup {
    [self.coreDataStack clearStores];
    [self refreshLocalData];
}

- (void)cleanupLocalMenus {
    if (self.localRestaurants) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        [calendar setTimeZone:timeZone];
        
        NSDate *today = [NSDate date];
        NSDateComponents *todaysComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:today];
        
        //[todaysComponents setDay:[todaysComponents day] - 1];        
        NSDate *yesterday = [calendar dateFromComponents:todaysComponents];
        
        for (Restaurant *r in self.localRestaurants) {            
            for (MenuSet *ms in r.menuSet) {
                NSDate *menuSetDate = [ms date];
                if (menuSetDate == [menuSetDate earlierDate:yesterday]) {
                    [[self.coreDataStack managedObjectContext] deleteObject:ms];
                }
            }
            
            [self.coreDataStack saveContext];
        }
    }
}

- (NSArray *)localRestaurants {    
    return [SFDataAccessor localRestaurants];
}

#pragma mark Download

- (void)downloadRestaurants {
    [self performSelectorInBackground:@selector(doDownloadRestaurants) withObject:nil];
}

- (void)doDownloadRestaurants {
    // call the API here
    BOOL success = NO;
    @try {
        success = [[Connection sharedConnection] readRestaurants];
    }
    @catch (NSException *exception) {
        [self performSelectorOnMainThread:@selector(raiseAlertOnMainThread:) withObject:exception waitUntilDone:YES];
        return;
    }
    
    [self performSelectorOnMainThread:@selector(finishedDownloadRestaurants:) withObject:[NSNumber numberWithBool:success] waitUntilDone:YES];
}

- (void)finishedDownloadRestaurants:(BOOL)success {
    // get the restaurants here and fetch all the menus for each restaurant
    [NSNotificationCenter.defaultCenter postNotification:[NSNotification notificationWithName:RESTAURANTS_UPDATED_NOTIFICATION object:nil]];
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
        [self performSelectorOnMainThread:@selector(raiseAlertOnMainThread:) withObject:exception waitUntilDone:YES];
    }
    
    [self performSelectorOnMainThread:@selector(finishedDownloadMenusForRestaurant:) withObject:[NSNumber numberWithBool:success] waitUntilDone:YES];
}

- (void)finishedDownloadMenusForRestaurant:(BOOL)success {
    [NSNotificationCenter.defaultCenter postNotification:[NSNotification notificationWithName:MENUS_UPDATED_NOTIFICATION object:nil]];
}

- (void)raiseAlertOnMainThread:(NSException *)exception {
    NSLog(@"Error %@: %@", [exception reason], [exception description]);
    
    UIViewController *topViewController = [UIApplication topViewController:nil];
    
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [topViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hoppla..." message:@"Da ist etwas schiefgelaufen, sorry. Probier's später bitte noch einmal." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:okayAction];

    [topViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
