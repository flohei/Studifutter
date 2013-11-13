//
//  SFTeamListViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 13/11/13.
//  Copyright (c) 2013 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFTeamListViewController.h"
#import "SFWebViewController.h"

@interface SFTeamListViewController ()

@end

@implementation SFTeamListViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    
    if ([segueIdentifier isEqualToString:@"ShowFloheiSegue"]) {
        NSURL *url = [NSURL URLWithString:@"http://flohei.de"];
        SFWebViewController *webViewController = (SFWebViewController *)[segue destinationViewController];
        [webViewController setWebURL:url];
        
    } else if ([segueIdentifier isEqualToString:@"ShowLTFSegue"]) {
        NSURL *url = [NSURL URLWithString:@"http://vonvon.de"];
        SFWebViewController *webViewController = (SFWebViewController *)[segue destinationViewController];
        [webViewController setWebURL:url];
    }
}

@end
