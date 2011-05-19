//
//  Meal.h
//  Studifutter
//
//  Created by Florian Heiber on 20.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Meal : NSObject {
	NSString *title;
	NSNumber *price;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *price;

@end
