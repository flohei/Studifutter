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
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]
                                                         initWithTarget:self 
                                                         action:@selector(shareOptions:)];
    longPressRecognizer.minimumPressDuration = 0.5;
    longPressRecognizer.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:longPressRecognizer];
}

- (IBAction)shareOptions:(UIGestureRecognizer *)sender {
    //NSLog(@"Show share kit here");
}

- (void)updateLabels {
    [nameLabel setText:[[self menu] name]];
    
    NSMutableString *infoString = [NSMutableString stringWithFormat:@"%.2f€/%.2f€", _menu.priceValue, _menu.reducedPriceValue];
    
    if (_menu.extraChars.length > 0) {
        [infoString appendFormat:@" - %@", _menu.extraChars];
    }
    
    if (_menu.extraNumbers.length > 0) {
        [infoString appendFormat:@" - %@", _menu.extraNumbers];
    }
    
    [infoLabel setText:infoString];
}

@end
