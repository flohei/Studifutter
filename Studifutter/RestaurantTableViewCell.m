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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;
    [self updateLabels];
}

- (void)updateLabels {
    [restaurantNameLabel setText:[[self restaurant] name]];
    
    NSString *addressString = [NSString stringWithFormat:@"%@, %@", [[self restaurant] street], [[self restaurant] city]];
    [restaurantAddressLabel setText:addressString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
