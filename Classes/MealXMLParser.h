//
//  XMLParser.h
//  Studifutter
//
//  Created by Florian Heiber on 20.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RawMeal.h"

@interface MealXMLParser : NSObject {
	NSMutableString *currentProperty;
	RawMeal *currentRawMeal;
	NSMutableArray *rawMeals;
	NSMutableArray *mealSets;
	BOOL success;
}

@property (nonatomic, retain) NSMutableString *currentProperty;
@property (nonatomic, retain) RawMeal *currentRawMeal;
@property (nonatomic, retain) NSMutableArray *rawMeals;
@property (nonatomic, retain) NSMutableArray *mealSets;
@property (readonly) BOOL success;

- (NSArray *)fetchMealsWithXMLURL:(NSURL *)xmlURL;
- (NSNumber *)parsePriceString:(NSString *)prices;

@end
