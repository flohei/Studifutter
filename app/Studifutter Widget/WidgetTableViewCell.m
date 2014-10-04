//
//  WidgetTableViewCell.m
//  Studifutter
//
//  Created by Florian Heiber on 04/10/14.
//  Copyright (c) 2014 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "WidgetTableViewCell.h"

@implementation WidgetTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
