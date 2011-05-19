//
//  RawMeal.h
//  Studifutter
//
//  Created by Florian Heiber on 28.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RawMeal : NSObject {
	NSDate *date;
	NSString *text;
	NSString *regularPrice;
	NSString *specialPrice;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *regularPrice;
@property (nonatomic, retain) NSString *specialPrice;

@end
