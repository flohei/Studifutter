//
//  MenuTableViewCell.h
//  Studifutter
//
//  Created by Florian Heiber on 23.11.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Menu;

@interface MenuTableViewCell : UITableViewCell {
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *infoLabel;
    IBOutlet UIImageView *backgroundImageView;
}

@property (nonatomic, retain) Menu *menu;

@end
