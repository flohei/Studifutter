//
//  RestaurantListViewController.h
//  Mensa
//
//  Created by Florian Heiber on 02.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RestaurantListViewController : UITableViewController {
	NSArray *restaurantArray;
}

@property (nonatomic, retain) NSArray *restaurantArray;

- (NSArray *)createRestaurantArray;
- (id)initWithCurrentRestaurants:(NSMutableArray *)currentRestaurants;

@end
