//
//  SFDataAccessor.h
//  Studifutter
//
//  Created by Florian Heiber on 03.02.13.
//  Copyright (c) 2013 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Restaurant;

@interface SFDataAccessor : NSObject

+ (Restaurant *)restaurantByID:(NSNumber *)restaurantID;
+ (NSArray *)localRestaurants;

@end
