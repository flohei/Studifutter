//
//  FaveRestaurantListViewController.h
//  Studifutter
//
//  Created by Florian Heiber on 27.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FaveRestaurantListViewController : UITableViewController {
	NSMutableArray *faveRestaurants;
}

@property (nonatomic, retain) NSMutableArray *faveRestaurants;

- (id)initWithRestaurantArray:(NSMutableArray *)restaurants;
- (void)addRestaurant:(id)sender;

@end
