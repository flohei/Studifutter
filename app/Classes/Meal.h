//
//  Meal.h
//  Mensa
//
//  Created by Florian Heiber on 29.03.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Meal : NSObject {
	NSString *text;
	NSString *day;
	NSDate *date;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *day;
@property (nonatomic, retain) NSDate *date;

- (NSArray *)getMealTexts;

@end
