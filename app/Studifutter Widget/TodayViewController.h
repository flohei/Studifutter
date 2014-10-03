//
//  TodayViewController.h
//  StudifutterToday
//
//  Created by Florian Heiber on 24.09.14.
//  Copyright (c) 2014 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface TodayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain, readonly) Restaurant *restaurant;
@property (nonatomic, retain, readonly) NSArray *menus;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSDictionary *sections;
@property (nonatomic, retain) NSArray *sortedMonths;

@end
