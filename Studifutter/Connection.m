//
//  Connection.m
//  Studifutter
//
//  Created by Florian Heiber on 01.11.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "Connection.h"
#import "SFAppDelegate.h"
#import "Reachability.h"
#import "SFAPICall.h"
#import "Restaurant.h"
#import "MenuSet.h"
#import "Menu.h"
#import "NSString+TrimWhitespace.h"


@interface Connection ()

- (NSNumber *)cleanPrice:(NSString *)priceString;
- (void)alertForException:(NSException *)exception;

@end

@implementation Connection

@synthesize hostReachable = _hostReachable;

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
    
    // allocate a reachability object
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.rtfnt.com"];
    
    // start the notifier which will cause the reachability object to retain itself!
    [reachability startNotifier];
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:_connection selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    return _connection;
}

- (void)reachabilityChanged:(NSNotification*)note {
    Reachability *reach = [note object];
    
    if ([reach isReachable]) {
        self.hostReachable = YES;
    }
    else {
        self.hostReachable = NO;
    }
}

/**
 Raises an UIAlertView for a given exception.
 
 @param exception The exception the NSAlert shall be created for.
 */
- (void)alertForException:(NSException *)exception {
    [self performSelectorOnMainThread:@selector(showAlertForException:) withObject:exception waitUntilDone:YES];
}

- (void)showAlertForException:(NSException *)exception {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"OOPS", @"Oops...")
//                                                        message:[exception reason]
//                                                       delegate:nil 
//                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK") 
//                                              otherButtonTitles:nil];
//    [alertView show];
    
    NSLog(@"Error %@: %@", [exception reason], [exception description]);
}

/**
 Returns the App's managed object context, saved in the App delegate.
 */
- (NSManagedObjectContext *)context {
    return [(SFAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
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
        //NSLog(@"%@", exception);
        @throw exception;
    }
    
    if (result) {
        int status = [[result objectForKey:@"status"] intValue];
        
        if (status == SF_API_STATUS_OK) {
            NSArray *rawRestaurants = [result objectForKey:@"data"];
            [self performSelectorOnMainThread:@selector(parseAndSaveRestaurants:) withObject:rawRestaurants waitUntilDone:YES];
            
            success = YES;
        }
    }
    
    return success;
}

- (void)parseAndSaveRestaurants:(NSArray *)rawRestaurants {
    for (NSDictionary *rawRestaurant in rawRestaurants) {
        NSNumber *newRestaurantID = ([rawRestaurant objectForKey:@"id"] != [NSNull null]) ? [NSNumber numberWithInt:[[rawRestaurant objectForKey:@"id"] intValue]] : nil;
        
        if (newRestaurantID) {
            // check if this new restaurant is already locally saved
            Restaurant *reference = [SFDataAccessor restaurantByID:newRestaurantID];
            
            if (reference) {
                // reference found. no need to parse this one.
                continue;
            }
        } else {
            // the new data does not have a restaurant id. meh.
            continue;
        }
        
        SFAppDelegate *delegate = (SFAppDelegate *)[[UIApplication sharedApplication] delegate];
        [[[delegate managedObjectContext] undoManager] beginUndoGrouping];
        
        Restaurant *aNewRestaurant = [[Restaurant alloc] initWithEntity:[NSEntityDescription entityForName:@"Restaurant" inManagedObjectContext:[self context]] insertIntoManagedObjectContext:[self context]];
        
        // ([rawMessage objectForKey:@"subject"] != [NSNull null]) ? [rawMessage objectForKey:@"subject"] : nil;
        aNewRestaurant.name = ([rawRestaurant objectForKey:@"name"] != [NSNull null]) ? [rawRestaurant objectForKey:@"name"] : nil;
        aNewRestaurant.restaurantID = newRestaurantID;
        aNewRestaurant.menuURL = ([rawRestaurant objectForKey:@"url"] != [NSNull null]) ? [rawRestaurant objectForKey:@"url"] : nil;
        aNewRestaurant.closed = ([rawRestaurant objectForKey:@"closed"] != [NSNull null]) ? [NSNumber numberWithBool:[[rawRestaurant objectForKey:@"closed"] boolValue]] : nil;
        aNewRestaurant.city = ([rawRestaurant objectForKey:@"city"] != [NSNull null]) ? [rawRestaurant objectForKey:@"city"] : nil;
        aNewRestaurant.longitude = ([rawRestaurant objectForKey:@"longitude"] != [NSNull null]) ? [NSNumber numberWithDouble:[[rawRestaurant objectForKey:@"longitude"] doubleValue]] : nil;
        aNewRestaurant.latitude = ([rawRestaurant objectForKey:@"latitude"] != [NSNull null]) ? [NSNumber numberWithDouble:[[rawRestaurant objectForKey:@"latitude"] doubleValue]] : nil;
        aNewRestaurant.notes = ([rawRestaurant objectForKey:@"notes"] != [NSNull null]) ? [rawRestaurant objectForKey:@"notes"] : nil;
        aNewRestaurant.street = ([rawRestaurant objectForKey:@"street"] != [NSNull null]) ? [rawRestaurant objectForKey:@"street"] : nil;
        aNewRestaurant.zipCode = ([rawRestaurant objectForKey:@"zipCode"] != [NSNull null]) ? [rawRestaurant objectForKey:@"zipCode"] : nil;
        
        
        [[[delegate managedObjectContext] undoManager] endUndoGrouping];
        [delegate saveContext];
    }
}

- (BOOL)readMenuForRestaurant:(Restaurant *)restaurant {
    BOOL success = NO;
    
    NSString *requestPath = [NSString stringWithFormat:@"/restaurant/%d/menu", [restaurant restaurantIDValue]];
    NSDictionary *result = nil;
    
    @try {
        result = [SFAPICall dictionaryFromRequestPath:requestPath postArgs:nil getArgs:nil];
    }
    @catch (NSException *exception) {
        @throw exception;
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
                    //NSLog(@"Getting the date for a MenuSet of restaurant %@ failed", restaurant);
                    continue;
                }
                
                // if the date is nil stop adding the new menu set
                if (!date) continue;
                
                // if the date is older than today stop adding it
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
                [calendar setTimeZone:timeZone];
                
                NSDate *today = [NSDate date];
                NSDateComponents *todaysComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
                NSDate *yesterday = [calendar dateFromComponents:todaysComponents];
                
                if ([date earlierDate:yesterday] == date) {
                    continue;
                }
                
                // compare the incoming date with the last one saved
                NSTimeInterval halfADay = 43200;
                if (lastDayOfOldMenus && date == [[lastDayOfOldMenus dateByAddingTimeInterval:halfADay] earlierDate:date]) continue;
                
                [[[(SFAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] undoManager] beginUndoGrouping];
                
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
                    
                    menu.name = (name != (id)[NSNull null]) ? [name trimWhitespace] : nil;
                    menu.price = (price != (id)[NSNull null]) ? price : nil;
                    menu.reducedPrice = (reducedPrice != (id)[NSNull null]) ? reducedPrice : nil;
                    menu.extraChars = (extraChars != (id)[NSNull null]) ? [meal objectForKey:@"extraChar"] : nil;
                    menu.extraNumbers = (extraNumbers != (id)[NSNull null]) ? [meal objectForKey:@"extraNumber"] : nil;
                    menu.currency = @"€";
                    
                    menu.menuSet = menuSet;
                }
                
                SFAppDelegate *delegate = (SFAppDelegate *)[[UIApplication sharedApplication] delegate];
                [[[delegate managedObjectContext] undoManager] endUndoGrouping];
                [delegate saveContext];
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
