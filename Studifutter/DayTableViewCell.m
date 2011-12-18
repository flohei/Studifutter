//
//  DayTableViewCell.m
//  Studifutter
//
//  Created by Florian Heiber on 09.11.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "DayTableViewCell.h"
#import "MenuSet.h"
#import "Menu.h"

@interface DayTableViewCell ()

- (void)updateLabels;

@end

@implementation DayTableViewCell

@synthesize menuSet = _menuSet;

- (void)setMenuSet:(MenuSet *)menuSet {
    _menuSet = menuSet;
    
    [self updateLabels];
}

- (void)updateLabels {
    NSString *dateString = nil;
    NSString *menuString = [NSString string];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd."];
    
    dateString = [dateFormatter stringFromDate:[[self menuSet] date]];
    [dateLabel setText:dateString];
    
    for (Menu *menu in [[self menuSet] menu]) {
        if (![menuString isEqualToString:[NSString string]]) {
            menuString = [menuString stringByAppendingString:@", "];
        }
        
        menuString = [menuString stringByAppendingString:[menu name]];
    }

    [menuLabel setText:menuString];
}

@end
