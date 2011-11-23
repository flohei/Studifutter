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
    NSString *menuString = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd."];
    
    dateString = [dateFormatter stringFromDate:[[self menuSet] date]];
    [dateLabel setText:dateString];

    // TODO: Localize "zum Beispiel"
    menuString = [NSString stringWithFormat:@"%@: %@", @"zum Beispiel", [[[[self menuSet] menu] anyObject] name]];
    [menuLabel setText:menuString];
}

@end
