//
//  Meal.m
//  Mensa
//
//  Created by Florian Heiber on 29.03.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "MealSet.h"


@implementation MealSet
@synthesize meals, date;

- (void)dealloc {
	[meals release];
	[date release];
	[super dealloc];
}

@end
