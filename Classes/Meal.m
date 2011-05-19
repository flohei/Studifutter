//
//  Meal.m
//  Mensa
//
//  Created by Florian Heiber on 29.03.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "Meal.h"


@implementation Meal
@synthesize text, day, date;

- (NSArray *)getMealTexts
{
	return [self.text componentsSeparatedByString:@"\n"];
}

- (id) initWithCoder:(NSCoder *)coder {
	text = [[coder decodeObjectForKey:@"text"] retain];
	day = [[coder decodeObjectForKey:@"day"] retain];
	date = [[coder decodeObjectForKey:@"date"] retain];
	return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:text forKey:@"text"];
	[encoder encodeObject:day forKey:@"day"];
	[encoder encodeObject:date forKey:@"date"];
}

@end
