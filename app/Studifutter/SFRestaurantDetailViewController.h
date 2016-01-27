//
//  SFRestaurantDetailViewController.h
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Restaurant;

@interface SFRestaurantDetailViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, retain) Restaurant *restaurant;
- (IBAction)favoriteToggled:(id)sender;

@end
