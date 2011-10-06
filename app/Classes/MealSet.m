//
//  Meal.m
//  Mensa
//
//  Created by Florian Heiber on 29.03.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "MealSet.h"
#import "Meal.h"


@implementation MealSet
@synthesize meals, date, text;

- (NSArray *)getMealTexts {
    NSMutableArray *texts = [[NSMutableArray alloc] init];
    
    for (Meal *m in meals) {
        [texts addObject:m.text];
    }
    
    return [texts autorelease];
}

- (void)dealloc {
	[meals release];
	[date release];
    [text release];
	[super dealloc];
}

@end
