//
//  XMLParser.h
//  Studifutter
//
//  Created by Florian Heiber on 20.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Meal;

@interface XMLParser : NSObject <NSXMLParserDelegate> {
	NSMutableString *currentProperty;
	Meal *currentMeal;
	NSMutableArray *parsedArray;
	NSMutableArray *meals;
	BOOL success;
}

@property (nonatomic, retain) NSMutableString *currentProperty;
@property (nonatomic, retain) Meal *currentMeal;
@property (nonatomic, retain) NSMutableArray *parsedArray;
@property (nonatomic, retain) NSMutableArray *meals;
@property (readonly) BOOL success;

- (NSArray *)fetchMealsWithXMLURL:(NSURL *)xmlURL;

@end
