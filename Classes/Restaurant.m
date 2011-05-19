//
//  Mensa.m
//  Mensa
//
//  Created by Florian Heiber on 07.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "Restaurant.h"
#import "MealSet.h"
#import "MealXMLParser.h"

@implementation Restaurant
@synthesize mealSets, image, name, street, zipcode, city, googleMapsURL, xmlURL;

- (void)initAndCleanup:(id)sender {
	[super init];
	[self cleanupArray];
}

// ****************************************************************************************
// 
// ****************************************************************************************
- (void)cleanupArray {
	// remove old meals
	NSDate *today = [NSDate date];
	// subtract one day (= 86400 seconds) for the today's
	// meals to be displayed
	today = [today addTimeInterval:-86400];
	NSDate *referenceDate, *earlierDate;
	
	NSMutableArray *mealsToRemove = [[NSMutableArray alloc] init];
	
	// mark all the meals to be removed in the array
	for (MealSet *ms in mealSets) {
		referenceDate = ms.date;
		earlierDate = [referenceDate earlierDate:today];
		
		if (referenceDate == earlierDate) {
			[mealsToRemove addObject:ms];
		}
	}
	
	// remove all the items in the new array
	for (MealSet *ms in mealsToRemove) {
		[mealSets removeObject:ms];
	}
	
	[mealsToRemove release];
}

- (void)refreshMeals {
	MealXMLParser *xmlParser = [[MealXMLParser alloc] init];
	NSMutableArray *temp = (NSMutableArray *)[xmlParser fetchMealsWithXMLURL:self.xmlURL];
	self.mealSets = temp;
	[temp release];
	[xmlParser release];
}

- (void)dealloc {
	[mealSets release];
	[name release];
	[street release];
	[zipcode release];
	[city release];
	[googleMapsURL release];
	[super dealloc];
}

@end
