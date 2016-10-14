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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // register for Crashlytics
    [Fabric with:@[[Crashlytics class]]];
    
    // setup appearance changes
    [self setupAppearance];
    
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
//        NSString *lastRestaurantKey = [[[NSUserDefaults alloc] initWithSuiteName:@"group.StudifutterContainer"] objectForKey:LAST_OPENED_RESTAURANT_ID];
//        if (lastRestaurantKey) {
//            Restaurant *lastRestaurant = (Restaurant *)[self.coreDataStack managedObjectForID:lastRestaurantKey];
//            if (lastRestaurant) {
//                SFDayListViewController *dayListViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"DayListViewController"];
//                [dayListViewController setRestaurant:lastRestaurant];
//                [navigationController pushViewController:dayListViewController animated:NO];
//            }
//        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error finding object: %@: %@", [exception name], [exception reason]);
    }
    
    return YES;
}

#pragma mark - Custom Code

- (void)setupAppearance {
    // Set the overall UINavigationBar's tint color to the Studifutter red. This mimics the iOS 7
    // style of Notes.app etc.
    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
