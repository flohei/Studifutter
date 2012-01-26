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
- (void)alertForException:(NSException *)exception;

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
 Raises an UIAlertView for a given exception.
 
 @param exception The exception the NSAlert shall be created for.
 */
- (void)alertForException:(NSException *)exception {
    [self performSelectorInBackground:@selector(showAlertForException:) withObject:exception];
}

- (void)showAlertForException:(NSException *)exception {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[exception name]
                                                        message:[exception reason]
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
    [alertView show];
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

- (BOOL)readRestaurants {
    BOOL success = NO;
    
    NSString *requestPath = @"/restaurant/list";
    NSDictionary *result = nil;
    
    @try {
        result = [SFAPICall dictionaryFromRequestPath:requestPath postArgs:nil getArgs:nil];
    }
    @catch (NSException *exception) {
        [self alertForException:exception];
        NSLog(@"%@", exception);
    }
    
    if (result) {
        int status = [[result objectForKey:@"status"] intValue];
        
        if (status == SF_API_STATUS_OK) {
            NSArray *rawRestaurants = [result objectForKey:@"data"];
            NSArray *localRestaurants = [(SFAppDelegate *)[[UIApplication sharedApplication] delegate] localRestaurants];
            
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
                BOOL notFound = YES;
                for (Restaurant *localRestaurant in localRestaurants) {
                    if ([[localRestaurant restaurantID] isEqualToNumber:[aNewRestaurant restaurantID]]) {
                        notFound = NO;
                    }
                }
                
                // save aNewRestaurant if it has not been found locally; delete it otherwise
                if (notFound) {
                    [(SFAppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
                    success = YES;
                } else {
                    [[self context] deleteObject:aNewRestaurant];
                }
            }
        }
    }
    
    return success;
}

- (BOOL)readMenuForRestaurant:(Restaurant *)restaurant {
    BOOL success = NO;
    
    NSString *requestPath = [NSString stringWithFormat:@"/restaurant/%d/menu", [restaurant restaurantIDValue]];
    NSDictionary *result = nil;
    
    @try {
        result = [SFAPICall dictionaryFromRequestPath:requestPath postArgs:nil getArgs:nil];
    }
    @catch (NSException *exception) {
        [self alertForException:exception];
        NSLog(@"%@", exception);
    }
    
    if (result) {
        int status = [[result objectForKey:@"status"] intValue];
        
        if (status == SF_API_STATUS_OK) {
            // get the last day of the currently locally saved menusets. do only save new ones
            // actually newer than the last date.
            NSDate *lastDayOfOldMenus = nil;
            NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
            NSArray *sortedMenuSets = [[restaurant menuSetSet] sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSortDescriptor]];
            if ([sortedMenuSets count] > 0) {
                MenuSet *lastMenuSet = [sortedMenuSets objectAtIndex:0];
                lastDayOfOldMenus = [lastMenuSet date];
            }
            
            NSArray *days = [result objectForKey:@"data"];
            
            for (NSDictionary *day in days) { 
                NSString *dateString = [day objectForKey:@"date"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd.MM.yy"];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
                NSDate *date;
                
                @try {
                    date = [dateFormatter dateFromString:dateString];
                }
                @catch (NSException *exception) {
                    NSLog(@"Getting the date for a MenuSet of restaurant %@ failed", restaurant);
                    continue;
                }
                
                // compare the incoming date with the last one saved
                NSTimeInterval halfADay = 43200;
                if (lastDayOfOldMenus && date == [[lastDayOfOldMenus dateByAddingTimeInterval:halfADay] earlierDate:date]) continue;
                
                MenuSet *menuSet = [[MenuSet alloc] initWithEntity:[NSEntityDescription entityForName:@"MenuSet" inManagedObjectContext:[self context]] insertIntoManagedObjectContext:[self context]];
                menuSet.restaurant = restaurant;
                menuSet.date = date;
                
                for (NSDictionary *meal in [day objectForKey:@"meals"]) {
                    Menu *menu = [[Menu alloc] initWithEntity:[NSEntityDescription entityForName:@"Menu" inManagedObjectContext:[self context]] insertIntoManagedObjectContext:[self context]];
                    
                    NSString *name = [meal objectForKey:@"title"];
                    NSString *priceString = [meal objectForKey:@"price2"];
                    NSString *reducedPriceString = [meal objectForKey:@"price1"];
                    NSString *extraChars = [meal objectForKey:@"extraChar"];
                    NSString *extraNumbers = [meal objectForKey:@"extraNumber"];
                    NSNumber *price = [self cleanPrice:priceString];
                    NSNumber *reducedPrice = [self cleanPrice:reducedPriceString];
                    
                    menu.name = (name != (id)[NSNull null]) ? [meal objectForKey:@"title"] : nil;
                    menu.price = (price != (id)[NSNull null]) ? price : nil;
                    menu.reducedPrice = (reducedPrice != (id)[NSNull null]) ? reducedPrice : nil;
                    menu.extraChars = (extraChars != (id)[NSNull null]) ? [meal objectForKey:@"extraChar"] : nil;
                    menu.extraNumbers = (extraNumbers != (id)[NSNull null]) ? [meal objectForKey:@"extraNumber"] : nil;
                    menu.currency = @"€";
                    
                    menu.menuSet = menuSet;
                }
                
                [(SFAppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
            }
            success = YES;
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

@end
