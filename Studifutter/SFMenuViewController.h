//
//  SFMenuViewController.h
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFTableViewController.h"
#import <UIKit/UIKit.h>

@class MenuSet;

@interface SFMenuViewController : SFTableViewController 

@property (nonatomic, retain) MenuSet *menuSet;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureRecognizer;
- (IBAction)showActionMenu:(id)sender;

@end
