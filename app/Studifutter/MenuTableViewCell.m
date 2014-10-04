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
    
    NSLocale *german = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:german];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSString *priceString1 = [formatter stringFromNumber:[_menu price]];
    NSString *priceString2 = [formatter stringFromNumber:[_menu reducedPrice]];
    
    NSMutableString *infoString = [NSMutableString stringWithFormat:@"%@/%@", priceString1, priceString2];
    
    if (_menu.extraChars.length > 0) {
        [infoString appendFormat:@" - %@", _menu.extraChars];
    }
    
    if (_menu.extraNumbers.length > 0) {
        [infoString appendFormat:@" - %@", _menu.extraNumbers];
    }
    
    [infoLabel setText:infoString];
}

@end
