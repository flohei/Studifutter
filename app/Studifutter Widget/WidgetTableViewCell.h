//
//  WidgetTableViewCell.h
//  Studifutter
//
//  Created by Florian Heiber on 04/10/14.
//  Copyright (c) 2014 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WidgetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *menuTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *menuPriceLabel;

@end
