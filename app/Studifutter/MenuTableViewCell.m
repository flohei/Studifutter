//
//  MenuTableViewCell.m
//  Studifutter
//
//  Created by Florian Heiber on 23.11.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "Menu.h"

@interface MenuTableViewCell ()

- (void)updateLabels;

@end

@implementation MenuTableViewCell

@synthesize menu = _menu;

- (void)setMenu:(Menu *)menu {
    _menu = menu;
    [self updateLabels];
}

- (void)updateLabels {
    [nameLabel setText:[[self menu] name]];
    
    NSString *infoString = [NSString stringWithFormat:@"%.2f€/%2f€ - %@ %@", _menu.priceValue/100, _menu.reducedPriceValue/100, _menu.extraChars, _menu.extraNumbers];
    [infoLabel setText:infoString];
}
@end
