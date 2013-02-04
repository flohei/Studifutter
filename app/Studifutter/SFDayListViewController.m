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
#import "SFRestaurantDetailViewController.h"
#import "TestFlight.h"
#import "FHGradientView.h"
#import "SFAppDelegate.h"

@interface SFDayListViewController ()

- (NSArray *)allMenus;

- (void)moveBannerOffScreen;
- (void)moveBannerOnScreen;

- (NSDate *)dateReducedToMonthForDate:(NSDate *)inputDate;

- (NSString *)monthStringForDate:(NSDate *)date;
- (void)reloadData:(NSNotification *)notification;

- (void)setupInfoView;
- (void)showInfoView;
- (void)hideInfoView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bannerVisibleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHiddenConstraint;

@end

@implementation SFDayListViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:MENUS_UPDATED_NOTIFICATION object:nil];
    
    bannerVisible = YES;
    [self moveBannerOffScreen];
    
    [[self tableView] setBackgroundColor:[UIColor clearColor]];
    
    NSString *titleString = nil;
    if ([[[self restaurant] name] length] > MAX_TITLE_LENGTH) {
        NSString *substring = [[[self restaurant] name] substringToIndex:MAX_TITLE_LENGTH - 1];
        titleString = [NSString stringWithFormat:@"%@…", substring];
    } else {
        titleString = [[self restaurant] name];
    }
    [[self navigationItem] setTitle:titleString];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setBannerView:nil];
    [self setTableView:nil];
    [self setContainerView:nil];
    [self setBannerHiddenConstraint:nil];
    [super viewDidUnload];    
    self.restaurant = nil;
}

#pragma mark - Misc

- (void)reloadData:(NSNotification *)notification {
    _sections = nil;
    [[self tableView] reloadData];
}

- (void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;
    
    [[NSUserDefaults standardUserDefaults] setObject:[[self restaurant] coreDataID] forKey:LAST_OPENED_RESTAURANT_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    SFAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate downloadMenuForRestaurant:_restaurant];
}

- (NSDictionary *)sections {
    if (!_sections) {
        NSMutableDictionary *mutableSections = [[NSMutableDictionary alloc] init];
        NSArray *allMenus = [self allMenus];
        NSMutableArray *monthArray = [[NSMutableArray alloc] init];
        
        for (MenuSet *menuSet in allMenus) {
            // get the month of the current menus date
            NSString *monthStringForDate = [self monthStringForDate:[menuSet date]];
            
            // if we don't have an array for the current month yet go ahead and create one
            NSMutableArray *menusInMonth = [mutableSections objectForKey:monthStringForDate];
            if (!menusInMonth) {
                menusInMonth = [[NSMutableArray alloc] init];
                [mutableSections setObject:menusInMonth forKey:monthStringForDate];
                [monthArray addObject:monthStringForDate];
            }
            
            // add the menu
            [menusInMonth addObject:menuSet];
        }
        
        _sections = (NSDictionary *)[mutableSections copy];
        mutableSections = nil;
        
        // create a list of sorted months
        self.sortedMonths = (NSArray *)monthArray;
    }
    
    return _sections;
}

- (NSArray *)allMenus {
    NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSSet *unsortedMenuSet = [[self restaurant] menuSet];
    
    if ([unsortedMenuSet count] == 0) {
        [self setupInfoView];
        [self showInfoView];
    } else {
        [self hideInfoView];
    }
    
    return [unsortedMenuSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSortDescriptor]];
}

- (NSDate *)dateReducedToMonthForDate:(NSDate *)inputDate {
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSMonthCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setDay:0];
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back       
    NSDate *month = [calendar dateFromComponents:dateComps];
    return month;
}

- (NSString *)monthStringForDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:date];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowMenu"]) {
        SFMenuViewController *menuViewController = (SFMenuViewController *)[segue destinationViewController];
        menuViewController.menuSet = [(DayTableViewCell *)sender menuSet];
    } else if ([[segue identifier] isEqualToString:@"ShowRestaurantDetails"]) {
        SFRestaurantDetailViewController *restaurantDetailViewController = (SFRestaurantDetailViewController *)[segue destinationViewController];
        restaurantDetailViewController.restaurant = self.restaurant;
    }
}

- (NSLayoutConstraint *)bannerHiddenConstraint {
    if (!_bannerHiddenConstraint) {
        _bannerHiddenConstraint = [NSLayoutConstraint constraintWithItem:_bannerView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_containerView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0
                                                                constant:50.0];
    }
    
    return _bannerHiddenConstraint;
}

- (void)setupInfoView {
    if (!infoView) {
        int width = 198;
        int height = 142;
        CGRect frame = CGRectMake(30, 10, width, height);
        infoView = [[UIView alloc] initWithFrame:frame];
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"studifutter-post-it.png"]];
        [image setFrame:frame];
        [image setCenter:[infoView center]];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:[image bounds]];
        NSString *infoText = NSLocalizedString(@"NO_MENUS_INFO_TEXT", @"Infotext, der angezeigt wird, wenn keine Menus vorhanden sind.");
        [infoLabel setBackgroundColor:[UIColor clearColor]];
        [infoLabel setText:infoText];
        [infoLabel setFont:[UIFont fontWithName:@"Marker Felt" size:16]];
        [infoLabel setCenter:[infoView center]];
        [infoLabel setNumberOfLines:0];
        [infoLabel setTextAlignment:NSTextAlignmentCenter];
        
        [infoView setBackgroundColor:[UIColor clearColor]];
        [infoView addSubview:image];
        [infoView addSubview:infoLabel];
    }
}

- (void)showInfoView {
    [[[self tableView] superview] addSubview:infoView];
}

- (void)hideInfoView {
    [infoView removeFromSuperview];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *currentMonth = [[self sortedMonths] objectAtIndex:section];
    NSArray *menusThatMonth = [[self sections] objectForKey:currentMonth];
    return [menusThatMonth count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DayCellIdentifier";
    
    DayTableViewCell *cell = (DayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    FHGradientView *backgroundView = [[FHGradientView alloc] initWithFrame:[cell bounds]];
    [cell setSelectedBackgroundView:backgroundView];
    
    // Configure the cell...
    NSDate *currentMonth = [[self sortedMonths] objectAtIndex:[indexPath section]];
    NSArray *menusThatMonth = [[self sections] objectForKey:currentMonth];
    
    MenuSet *menuSet = [menusThatMonth objectAtIndex:[indexPath row]];
    cell.menuSet = menuSet;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *monthName = [self.sortedMonths objectAtIndex:section];
    return monthName;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 44)];
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    [label setText:title];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    
    [containerView setBackgroundColor:[UIColor blackColor]];
    [containerView addSubview:label];
    
    return containerView;
}

#pragma mark - iAds

- (void)moveBannerOffScreen {
    if (!bannerVisible) return;
    
    // layout to starting position  
    [_containerView layoutIfNeeded];
    
    [UIView animateWithDuration:.5 animations:^{
        [_containerView removeConstraint:[self bannerVisibleConstraint]];
        [_containerView addConstraint:[self bannerHiddenConstraint]];
        [_containerView layoutIfNeeded];
    }];
    
    bannerVisible = NO;
}

- (void)moveBannerOnScreen {
    if (bannerVisible) return;
    
    // layout to starting position
    [_containerView layoutIfNeeded];
    
    [UIView animateWithDuration:.5 animations:^{
        [_containerView removeConstraint:[self bannerHiddenConstraint]];
        [_containerView addConstraint:[self bannerVisibleConstraint]];
        [_containerView layoutIfNeeded];
    }];
    
    bannerVisible = YES;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self moveBannerOnScreen];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self moveBannerOffScreen];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    [TestFlight passCheckpoint:AD_WATCHED_CHECKPOINT];
    return YES;
}

@end
