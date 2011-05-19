//
//  RestaurantXMLParser.h
//  Studifutter
//
//  Created by Florian Heiber on 28.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface RestaurantXMLParser : NSObject {
	NSMutableString *currentProperty;
	NSMutableArray *restaurants;
	Restaurant *currentRestaurant;
}

@property (nonatomic, retain) NSMutableString *currentProperty;
@property (nonatomic, retain) NSMutableArray *restaurants;
@property (nonatomic, retain) Restaurant *currentRestaurant;

- (NSArray *)fetchRestaurants;

@end
