//
//  TodayViewController.m
//  StudifutterToday
//
//  Created by Florian Heiber on 24.09.14.
//  Copyright (c) 2014 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "FHCoreDataStack.h"
#import "DayTableViewCell.h"
#import "MenuSet.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
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
    NSSet *unsortedMenuSet = self.restaurant.menuSet;
    
    if ([unsortedMenuSet count] == 0) {
        // show info that there's no data
//        [[self view] addSubview:[self noDataAvailableLabel]];
        [[self tableView] setHidden:YES];
    } else {
        // hide info that there's no data
        [[self view] removeFromSuperview];
        [[self tableView] setHidden:NO];
    }
    
    if (unsortedMenuSet) {
        return [unsortedMenuSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSortDescriptor]];
    } else {
        return nil;
    }
}

- (NSString *)monthStringForDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:date];
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
