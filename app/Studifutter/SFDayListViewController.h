//
//  SFDayListViewController.h
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAD/iAD.h>

@class Restaurant;

@interface SFDayListViewController : UIViewController <ADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    UIView *infoView;
}

@property (nonatomic, retain) Restaurant *restaurant;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSDictionary *sections;
@property (nonatomic, retain) NSArray *sortedMonths;

@end
