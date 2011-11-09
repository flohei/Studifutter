//
//  SFDayListViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFDayListViewController.h"
#import "Restaurant.h"
#import "MenuSet.h"
#import "Menu.h"
#import "DayTableViewCell.h"
#import "SFMenuViewController.h"

@interface SFDayListViewController ()

- (NSArray *)allMenus;

- (void)moveBannerOffScreen;
- (void)moveBannerOnScreen;

@end

@implementation SFDayListViewController

@synthesize restaurant = _restaurant;
@synthesize bannerView = _bannerView;
@synthesize tableView = _tableView;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    bannerVisible = YES;
    [self moveBannerOffScreen];
}

- (void)viewDidUnload
{
    [self setBannerView:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.restaurant = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Misc

- (NSArray *)allMenus {
    NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    return [[[self restaurant] menuSet] sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSortDescriptor]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"DayList"]) {
        SFMenuViewController *menuViewController = (SFMenuViewController *)[segue destinationViewController];
        menuViewController.menuSet = [(DayTableViewCell *)sender menuSet];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self allMenus] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DayCellIdentifier";
    
    DayTableViewCell *cell = (DayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    MenuSet *menuSet = [[self allMenus] objectAtIndex:[indexPath row]];
    cell.menuSet = menuSet;
    
    return cell;
}

#pragma mark - ADBannerViewDelegate

- (void)moveBannerOffScreen {   
    if (!bannerVisible) return;
    
    float offset = self.bannerView.frame.size.height;
    
    CGRect bannerFrame = [[self bannerView] frame];
    bannerFrame.origin.y += offset;
    
    CGRect tableFrame = [[self tableView] frame];
    tableFrame.size.height += offset;
    
    [UIView beginAnimations:@"MoveAdOffScreen" context:nil];
    [[self bannerView] setFrame:bannerFrame];
    [[self tableView] setFrame:tableFrame];
    [UIView commitAnimations];
    
    bannerVisible = NO;
}

- (void)moveBannerOnScreen {
    if (bannerVisible) return;
    
    float offset = self.bannerView.frame.size.height;
    
    CGRect bannerFrame = [[self bannerView] frame];
    bannerFrame.origin.y -= offset;
    
    CGRect tableFrame = [[self tableView] frame];
    tableFrame.size.height -= offset;
    
    [UIView beginAnimations:@"MoveAdOnScreen" context:nil];
    [[self bannerView] setFrame:bannerFrame];
    [[self tableView] setFrame:tableFrame];
    [UIView commitAnimations];
    
    bannerVisible = YES;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self moveBannerOnScreen];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self moveBannerOffScreen];
}

@end
