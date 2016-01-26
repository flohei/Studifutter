//
//  SFTeamListViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 13/11/13.
//  Copyright (c) 2013 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFTeamListViewController.h"

@import SafariServices;

@interface SFTeamListViewController ()

@end

@implementation SFTeamListViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFSafariViewController *safariViewController = nil;
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        NSURL *url = [NSURL URLWithString:@"http://vonvon.de"];
        safariViewController = [[SFSafariViewController alloc] initWithURL:url];
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        NSURL *url = [NSURL URLWithString:@"http://flohei.de"];
        safariViewController = [[SFSafariViewController alloc] initWithURL:url];
    }
    
    if (safariViewController) {
        [[self navigationController] pushViewController:safariViewController animated:YES];
    }
}

@end
