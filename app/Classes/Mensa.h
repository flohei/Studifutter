//
//  Mensa.h
//  Mensa
//
//  Created by Florian Heiber on 07.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mensa : NSObject {
	NSMutableArray *mealSets;
	NSString *name;
	NSString *street;
	NSString *zipcode;
	NSString *city;
	NSURL *googleMapsURL;
}

@property (nonatomic, retain) NSMutableArray *mealSets;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *zipcode;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSURL *googleMapsURL;

- (void)cleanupArray;

@end
