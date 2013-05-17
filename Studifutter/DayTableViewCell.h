//
//  DayTableViewCell.h
//  Studifutter
//
//  Created by Florian Heiber on 09.11.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuSet;

@interface DayTableViewCell : UITableViewCell {
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *menuLabel;
}

@property (nonatomic, retain) MenuSet *menuSet;

@end
