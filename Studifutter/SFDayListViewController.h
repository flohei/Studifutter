//
//  SFDayListViewController.h
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFViewController.h"
#import <UIKit/UIKit.h>
#import <iAD/iAD.h>

@class Restaurant;

@interface SFDayListViewController : SFViewController <ADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    bool bannerVisible;
}

@property (nonatomic, retain) Restaurant *restaurant;
@property (strong, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSDictionary *sections;
@property (nonatomic, retain) NSArray *sortedMonths;

@end