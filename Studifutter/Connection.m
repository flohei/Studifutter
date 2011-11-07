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
    NSDictionary *result = [SFAPICall dictionaryFromRequestPath:requestPath postArgs:nil getArgs:nil];
    
    return success;
}

- (bool)readMenuForRestaurant:(Restaurant *)restaurant {
    bool success = NO;
    
    NSString *requestPath = [NSString stringWithFormat:@"/restaurant/%d/menu", [restaurant restaurantIDValue]];
    
    return success;
}

@end
