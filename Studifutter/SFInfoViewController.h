//
//  SFInfoViewController.h
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFViewController.h"
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@protocol SFInfoViewDelegate

- (void)dismissInfoView;

@end

@interface SFInfoViewController : SFViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, assign) id <SFInfoViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)done:(id)sender;
- (IBAction)feedback:(id)sender;
- (IBAction)mail:(id)sender;
- (IBAction)twitter:(id)sender;

@end
