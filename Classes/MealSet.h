//
//  Meal.h
//  Mensa
//
//  Created by Florian Heiber on 29.03.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Meal;

@interface MealSet : NSObject {
	NSDate *date;
	NSMutableArray *meals;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSMutableArray *meals;

@end
