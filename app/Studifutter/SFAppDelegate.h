//
//  SFAppDelegate.h
//  Studifutter
//
//  Created by Florian Heiber on 29.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSURL *)applicationDocumentsDirectory;

- (void)refreshLocalData;
- (void)completeCleanup;

- (NSArray *)localRestaurants;

@end
