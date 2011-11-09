//
//  SFDayListViewController.h
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Restaurant;

@interface SFDayListViewController : UITableViewController

@property (nonatomic, retain) Restaurant *restaurant;

@end
