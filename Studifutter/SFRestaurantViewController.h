//
//  SFRestaurantViewController.h
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFTableViewController.h"
#import <UIKit/UIKit.h>
#import "SFInfoViewController.h"

@interface SFRestaurantViewController : SFTableViewController <SFInfoViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
