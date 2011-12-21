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
    
    NSMutableString *infoString = [NSMutableString stringWithFormat:@"%.2f€/%.2f€", _menu.priceValue, _menu.reducedPriceValue];
    
    if (![_menu.extraChars isEqualToString:@""]) {
        [infoString appendFormat:@" - %@", _menu.extraChars];
    }
    
    if (![_menu.extraNumbers isEqualToString:@""]) {
        [infoString appendFormat:@" - %@", _menu.extraNumbers];
    }
    
    [infoLabel setText:infoString];
}
@end
