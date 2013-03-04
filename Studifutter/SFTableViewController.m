//
//  SFTableViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 24.11.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFTableViewController.h"
#import "SFAppDelegate.h"


@implementation SFTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self tableView] setBackgroundColor:[UIColor clearColor]];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"studifutter-pattern"]]];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        [(SFAppDelegate *)[[UIApplication sharedApplication] delegate] refreshLocalData];
    }
}

@end
