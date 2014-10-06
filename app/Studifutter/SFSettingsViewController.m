//
//  SFSettingsViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 26.09.12.
//  Copyright (c) 2012 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFSettingsViewController.h"
#import "SFAppDelegate.h"
#import "SFWebViewController.h"

@interface SFSettingsViewController ()

@end

@implementation SFSettingsViewController

- (void)viewDidLoad {
    [[self userLocationSwitch] setOn:[[NSUserDefaults standardUserDefaults] boolForKey:SHOW_USER_LOCATION]];
    [[self userLocationSwitch] addTarget:self action:@selector(userLocationSwitchChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)userLocationSwitchChanged:(UIEvent *)event {
    [[NSUserDefaults standardUserDefaults] setBool:[[self userLocationSwitch] isOn] forKey:SHOW_USER_LOCATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    
    if ([segueIdentifier isEqualToString:@"ShowTwitterSegue"]) {
        NSURL *url = [NSURL URLWithString:@"http://twitter.com/studifutter"];
        SFWebViewController *webViewController = (SFWebViewController *)[segue destinationViewController];
        [webViewController setWebURL:url];
    } else if ([segueIdentifier isEqualToString:@"ShowWebsiteSegue"]) {
        NSURL *url = [NSURL URLWithString:@"http://rtfnt.com"];
        SFWebViewController *webViewController = (SFWebViewController *)[segue destinationViewController];
        [webViewController setWebURL:url];
    }
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentMailSheet {
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    [mailComposeViewController setMailComposeDelegate:self];
    [mailComposeViewController setToRecipients:@[@"studifutter@rtfnt.com"]];
    [mailComposeViewController setSubject:@"Comments, Suggestions, etc."];
    
    [self presentViewController:mailComposeViewController animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        SFAppDelegate *delegate = (SFAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate completeCleanup];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        [self presentMailSheet];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *title = [NSString string];
    
    if (section == 0) {
        title = NSLocalizedString(@"REDOWNLOAD_DESCRIPTION", @"Erneuter Download aller Restaurant und Menüs – falls mal was schief läuft.");
    } else if (section == 2) {
        title = [NSString stringWithFormat:@"Version %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    }
    
    return title;
}

@end
