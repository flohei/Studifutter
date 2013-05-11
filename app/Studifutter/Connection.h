//
//  Connection.h
//  Studifutter
//
//  Created by Florian Heiber on 01.11.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;
@class Restaurant;

@interface Connection : NSObject

+ (Connection *)sharedConnection;

@property BOOL hostReachable;
- (void)reachabilityChanged:(NSNotification*)note;

@property (nonatomic, retain) NSManagedObjectContext *context;

- (BOOL)readRestaurants;
- (BOOL)readMenuForRestaurant:(Restaurant *)restaurant;

@end
