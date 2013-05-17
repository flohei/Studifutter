//
//  RestaurantTableViewCell.h
//  Studifutter
//
//  Created by Florian Heiber on 09.11.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Restaurant;

@interface RestaurantTableViewCell : UITableViewCell {
    IBOutlet UILabel *restaurantNameLabel;
    IBOutlet UILabel *restaurantAddressLabel;
}

@property (nonatomic, retain) Restaurant *restaurant;

@end
