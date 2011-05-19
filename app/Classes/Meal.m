//
//  Meal.m
//  Studifutter
//
//  Created by Florian Heiber on 20.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "Meal.h"

@implementation Meal
@synthesize title, price;

- (id) initWithCoder:(NSCoder *)coder {
	title = [[coder decodeObjectForKey:@"text"] retain];
	price = [[coder decodeObjectForKey:@"price"] retain];
	return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:title forKey:@"title"];
	[encoder encodeObject:price forKey:@"price"];
}

@end
