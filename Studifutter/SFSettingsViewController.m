//
//  SFSettingsViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 26.09.12.
//  Copyright (c) 2012 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFSettingsViewController.h"
#import "SFAppDelegate.h"

@interface SFSettingsViewController ()

@end

@implementation SFSettingsViewController

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        SFAppDelegate *delegate = (SFAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate completeCleanup];
    }
}

@end
