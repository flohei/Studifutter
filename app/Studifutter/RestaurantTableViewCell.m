//
//  RestaurantTableViewCell.m
//  Studifutter
//
//  Created by Florian Heiber on 09.11.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "RestaurantTableViewCell.h"
#import "Restaurant.h"

@interface RestaurantTableViewCell ()

- (void)updateLabels;

@end

@implementation RestaurantTableViewCell

@synthesize restaurant = _restaurant;

- (void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;
    [self updateLabels];
}

- (void)updateLabels {
    [restaurantNameLabel setText:[[self restaurant] name]];
    
    NSString *addressString = [NSString stringWithFormat:@"%@, %@", [[self restaurant] street], [[self restaurant] city]];
    [restaurantAddressLabel setText:addressString];
}

@end
