//
//  SFTableViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 24.11.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFTableViewController.h"


@implementation SFTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self tableView] setBackgroundColor:[UIColor clearColor]];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"studifutter-pattern"]]];
}

@end
