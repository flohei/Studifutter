//
//  SFInfoViewController.h
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SFInfoViewDelegate

- (void)dismissInfoView;

@end

@interface SFInfoViewController : UIViewController

@property (nonatomic, assign) id <SFInfoViewDelegate> delegate;

- (IBAction)done:(id)sender;

@end
