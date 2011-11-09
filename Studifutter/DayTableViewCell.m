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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setMenuSet:(MenuSet *)menuSet {
    _menuSet = menuSet;
    
    [self updateLabels];
}

- (void)updateLabels {
    NSString *dateString = nil;
    NSMutableString *menuString = [NSMutableString string];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd."];
    
    dateString = [dateFormatter stringFromDate:[[self menuSet] date]];
    
    for (Menu *menu in [[self menuSet] menu]) {
        [menuString appendFormat:@"%@, ", [menu name]];
    }
    
    [dateLabel setText:dateString];
    
    // I know, this is ugly, but remove the last to symbols ", "
    [menuLabel setText:[menuString substringToIndex:[menuString length] - 3]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
