//
//  Meal.m
//  Studifutter
//
//  Created by Florian Heiber on 20.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "Meal.h"

@implementation Meal
@synthesize title, regularPrice, specialPrice;

- (id) initWithCoder:(NSCoder *)coder {
	title = [[coder decodeObjectForKey:@"text"] retain];
	regularPrice = [[coder decodeObjectForKey:@"regularPrice"] retain];
	specialPrice = [[coder decodeObjectForKey:@"specialPrice"] retain];
	
	return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:title forKey:@"title"];
	[encoder encodeObject:regularPrice forKey:@"regularPrice"];
	[encoder encodeObject:specialPrice forKey:@"specialPrice"];
}

@end
