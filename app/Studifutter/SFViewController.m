//
//  SFViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 24.11.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFViewController.h"
#import "SFAppDelegate.h"

@implementation SFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"studifutter-pattern"]]];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"Shake detected, reload data.");
        [(SFAppDelegate *)[[UIApplication sharedApplication] delegate] refreshLocalData];
    }
}

@end
