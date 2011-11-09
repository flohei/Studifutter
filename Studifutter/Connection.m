//
//  Connection.m
//  Studifutter
//
//  Created by Florian Heiber on 01.11.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "Connection.h"
#import "Constants.h"
#import "SFAppDelegate.h"
#import "Reachability.h"
#import "SFAPICall.h"
#import "Restaurant.h"
#import "MenuSet.h"
#import "Menu.h"


@interface Connection ()

- (NSNumber *)cleanPrice:(NSString *)priceString;

- (NSArray *)localRestaurants;

@end

@implementation Connection

@synthesize context = _context;
@synthesize internetReachable = _internetReachable;
@synthesize hostReachable = _hostReachable;
@synthesize internetActive = _internetActive;
@synthesize hostActive = _hostActive;
@synthesize sharedOperationQueue = _sharedOperationQueue;

static Connection *_connection;

/**
 Returns a Connection object to proivde access to the API.
 */
+ (Connection *)sharedConnection {
    @synchronized(self) {
        if (!_connection) {
            _connection = [[self alloc] init];
        }
    }
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:_connection selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    _connection.internetReachable = [Reachability reachabilityForInternetConnection];
    [_connection.internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    _connection.hostReachable = [Reachability reachabilityWithHostName:@"www.rtfnt.com"];
    [_connection.hostReachable startNotifier];
    
    // now patiently wait for the notification
    
    return _connection;
}

/**
 Checks if there is a network connection whenever the network status changes and and saves it 
 to self.internetActive and self.hostActive.
 
 @param notice The notification that invoked checkNetworkStatus:.
 */
- (void)checkNetworkStatus:(NSNotification *)notice {
    // called after network status changes
    
    NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus];
    switch (internetStatus) {
        case NotReachable: {
            NSLog(@"The internet is down.");
            self.internetActive = NO;
            
            break;
        }
        case ReachableViaWiFi: {
            //NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            
            break;
        }
        case ReachableViaWWAN: {
            //NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [self.hostReachable currentReachabilityStatus];
    switch (hostStatus) {
        case NotReachable: {
            //NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            
            break;
        }
        case ReachableViaWiFi: {
            //NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            
            break;
        }
        case ReachableViaWWAN: {
            //NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            
            break;
        }
    }
}

/**
 Returns the App's managed object context, saved in the App delegate.
 */
- (NSManagedObjectContext *)context {
    if (_context == nil)
        _context = [(SFAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    return _context;
}

- (NSOperationQueue *)sharedOperationQueue {
    if (!_sharedOperationQueue) {
        _sharedOperationQueue = [[NSOperationQueue alloc] init];
    }
    
    return _sharedOperationQueue;
}

- (bool)readRestaurants {
    bool success = NO;
    
    NSString *requestPath = @"/restaurant/list";
    NSDictionary *result = nil;
    
    @try {
        result = [SFAPICall dictionaryFromRequestPath:requestPath postArgs:nil getArgs:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    
    if (result) {
        int status = [[result objectForKey:@"status"] intValue];
        
        if (status == SF_API_STATUS_OK) {
            NSArray *rawRestaurants = [result objectForKey:@"data"];
            NSArray *localRestaurants = [self localRestaurants];
            
            for (NSDictionary *rawRestaurant in rawRestaurants) {
                Restaurant *aNewRestaurant = [[Restaurant alloc] initWithEntity:[NSEntityDescription entityForName:@"Restaurant" inManagedObjectContext:[self context]] insertIntoManagedObjectContext:[self context]];
                
                // ([rawMessage objectForKey:@"subject"] != [NSNull null]) ? [rawMessage objectForKey:@"subject"] : nil;
                aNewRestaurant.name = ([rawRestaurant objectForKey:@"name"] != [NSNull null]) ? [rawRestaurant objectForKey:@"name"] : nil;
                aNewRestaurant.restaurantID = ([rawRestaurant objectForKey:@"id"] != [NSNull null]) ? [NSNumber numberWithInt:[[rawRestaurant objectForKey:@"id"] intValue]] : nil;
                aNewRestaurant.menuURL = ([rawRestaurant objectForKey:@"url"] != [NSNull null]) ? [rawRestaurant objectForKey:@"url"] : nil;
                aNewRestaurant.closed = ([rawRestaurant objectForKey:@"closed"] != [NSNull null]) ? [NSNumber numberWithBool:[[rawRestaurant objectForKey:@"closed"] boolValue]] : nil;
                aNewRestaurant.city = ([rawRestaurant objectForKey:@"city"] != [NSNull null]) ? [rawRestaurant objectForKey:@"city"] : nil;
                aNewRestaurant.longitude = ([rawRestaurant objectForKey:@"longitude"] != [NSNull null]) ? [NSNumber numberWithDouble:[[rawRestaurant objectForKey:@"longitude"] doubleValue]] : nil;
                aNewRestaurant.latitude = ([rawRestaurant objectForKey:@"latitude"] != [NSNull null]) ? [NSNumber numberWithDouble:[[rawRestaurant objectForKey:@"latitude"] doubleValue]] : nil;
                aNewRestaurant.notes = ([rawRestaurant objectForKey:@"notes"] != [NSNull null]) ? [rawRestaurant objectForKey:@"notes"] : nil;
                aNewRestaurant.street = ([rawRestaurant objectForKey:@"street"] != [NSNull null]) ? [rawRestaurant objectForKey:@"street"] : nil;
                aNewRestaurant.zipCode = ([rawRestaurant objectForKey:@"zipCode"] != [NSNull null]) ? [rawRestaurant objectForKey:@"zipCode"] : nil;
                
                // check if aNewRestaurant is already locally saved
                bool notFound = YES;
                for (Restaurant *localRestaurant in localRestaurants) {
                    if ([[localRestaurant restaurantID] isEqualToNumber:[aNewRestaurant restaurantID]]) {
                        notFound = NO;
                    }
                }
                
                // save aNewRestaurant if it has not been found locally; delete it otherwise
                if (notFound) {
                    [(SFAppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
                } else {
                    [[self context] deleteObject:aNewRestaurant];
                }
            }
        }
    }
    
    return success;
}

- (bool)readMenuForRestaurant:(Restaurant *)restaurant {
    bool success = NO;
    
    NSString *requestPath = [NSString stringWithFormat:@"/restaurant/%d/menu", [restaurant restaurantIDValue]];
    NSDictionary *result = nil;
    
    @try {
        result = [SFAPICall dictionaryFromRequestPath:requestPath postArgs:nil getArgs:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    
    if (result) {
        int status = [[result objectForKey:@"status"] intValue];
        
        if (status == SF_API_STATUS_OK) {
            NSArray *days = [result objectForKey:@"data"];
            
            for (NSDictionary *day in days) {
                NSString *dateString = [day objectForKey:@"date"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd.MM.yy"];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
                NSDate *date = [dateFormatter dateFromString:dateString];
                
                MenuSet *menuSet = [[MenuSet alloc] initWithEntity:[NSEntityDescription entityForName:@"MenuSet" inManagedObjectContext:[self context]] insertIntoManagedObjectContext:[self context]];
                menuSet.restaurant = restaurant;
                menuSet.date = date;
                
                for (NSDictionary *meal in [day objectForKey:@"meals"]) {
                    Menu *menu = [[Menu alloc] initWithEntity:[NSEntityDescription entityForName:@"Menu" inManagedObjectContext:[self context]] insertIntoManagedObjectContext:[self context]];
                    
                    menu.name = ([meal objectForKey:@"title"] != [NSNull null]) ? [meal objectForKey:@"title"] : nil;
                    menu.price = ([meal objectForKey:@"price2"] != [NSNull null]) ? [self cleanPrice:[meal objectForKey:@"price2"]] : nil;
                    menu.reducedPrice = ([meal objectForKey:@"price1"] != [NSNull null]) ? [self cleanPrice:[meal objectForKey:@"price1"]] : nil;
                    menu.extraChars = ([meal objectForKey:@"extraChar"] != [NSNull null]) ? [meal objectForKey:@"extraChar"] : nil;
                    menu.extraNumbers = ([meal objectForKey:@"extraNumber"] != [NSNull null]) ? [meal objectForKey:@"extraNumber"] : nil;
                    menu.currency = @"€";
                    
                    menu.menuSet = menuSet;
                }
            }
            
            [(SFAppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
        }
    }
    
    return success;
}

#pragma mark - Helpers

- (NSNumber *)cleanPrice:(NSString *)priceString {
    NSRange spaceRange = [priceString rangeOfString:@" "];
    NSRange commaRange = [priceString rangeOfString:@","];
    
    NSString *cleanPriceString = priceString;
    NSNumber *cleanPrice = nil;
    
    if (spaceRange.location != NSNotFound) {
        cleanPriceString = [cleanPriceString substringToIndex:spaceRange.location];
    }
    
    if (commaRange.location != NSNotFound) {
        cleanPriceString = [cleanPriceString stringByReplacingOccurrencesOfString:@"," withString:@"."];
    }
    
    cleanPrice = [NSNumber numberWithFloat:[cleanPriceString floatValue]];
    
    return cleanPrice;
}

- (NSArray *)localRestaurants {    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Restaurant" inManagedObjectContext:[self context]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:self.context sectionNameKeyPath:nil 
                                                   cacheName:@"Restaurant"];
    
    NSError *error;
	if (![theFetchedResultsController performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    return [theFetchedResultsController fetchedObjects];
}

@end
