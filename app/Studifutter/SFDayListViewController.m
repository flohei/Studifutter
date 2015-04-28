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
#import "SFAppDelegate.h"
#import "SFRestaurantDetailViewController.h"

@interface SFDayListViewController () {
    UILabel *_noDataAvailableLabel;
}

- (NSArray *)allMenus;

- (NSDate *)dateReducedToMonthForDate:(NSDate *)inputDate;

- (NSString *)monthStringForDate:(NSDate *)date;
- (void)reloadData:(NSNotification *)notification;

@end

@implementation SFDayListViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:MENUS_UPDATED_NOTIFICATION object:nil];
    
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
    [self setTableView:nil];
    [self setContainerView:nil];
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
        // show info that there's no data
        UILabel *noDataAvailableLabel = [self noDataAvailableLabel];
        
        [[self containerView] addSubview:noDataAvailableLabel];
        [[self containerView] setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        // use constraints to get rid of weird layout issues when new phones appear
        NSDictionary *views = @{@"label":noDataAvailableLabel};
        NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[label]-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views];
        NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views];
        
        [[self containerView] addConstraints:[vConstraints arrayByAddingObjectsFromArray:hConstraints]];
        
        // hide the table
        [[self tableView] setHidden:YES];
    } else {
        // hide info that there's no data
        [[self noDataAvailableLabel] removeFromSuperview];
        [[self tableView] setHidden:NO];
    }
    
    if (unsortedMenuSet) {
         return [unsortedMenuSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSortDescriptor]];
    } else {
        return nil;
    }
}

- (UILabel *)noDataAvailableLabel {
    if (!_noDataAvailableLabel) {
        UIFont *theFont = nil;
        
        // check for iOS 7 or later
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            theFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        } else {
            theFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        }
        
        _noDataAvailableLabel = [UILabel new];
        [_noDataAvailableLabel setFont:theFont];
        [_noDataAvailableLabel setText:NSLocalizedString(@"NO_MENUS_INFO_TEXT", @"")];
        [_noDataAvailableLabel setBackgroundColor:[UIColor clearColor]];
        [_noDataAvailableLabel setNumberOfLines:0];
        [_noDataAvailableLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_noDataAvailableLabel setPreferredMaxLayoutWidth:200];
        [_noDataAvailableLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_noDataAvailableLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    return _noDataAvailableLabel;
}

- (NSDate *)dateReducedToMonthForDate:(NSDate *)inputDate {
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitMonth fromDate:inputDate];
    
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
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    [label setTextColor:[UIColor redColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    
    [containerView setBackgroundColor:[UIColor whiteColor]];
    [containerView addSubview:label];
    
    return containerView;
}

@end
