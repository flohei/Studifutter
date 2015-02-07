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
#import "WidgetTableViewCell.h"
#import "MenuSet.h"
#import "Menu.h"
#import "Constants.h"

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TodayViewController

@synthesize restaurant = _restaurant;
@synthesize menus = _menus;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 55.0;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(userDefaultsDidChange:)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];
    
    [self checkForAvailableDataAndShowInfo];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    [self reload];
    completionHandler(NCUpdateResultNewData);
}

- (void)userDefaultsDidChange:(NSNotification *)notification {
    [self reload];
}

- (NSString *)monthStringForDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:date];
}

- (void)reload {
    _restaurant = nil;
    _menus = nil;
    [[self tableView] reloadData];
    [self checkForAvailableDataAndShowInfo];
}

- (void)checkForAvailableDataAndShowInfo {
    NSString *errorString = nil;
    
    if (![self restaurant]) {
        // show a label that there is no restaurant set
        errorString = NSLocalizedString(@"NO_RESTAURANTS_INFO_TEXT", @"");
    }
    
    if ((![self menus] || [[self menus] count] == 0)
        && !errorString) {
        // show a label that there is no data available
        NSLog(@"no menus");
        errorString = NSLocalizedString(@"NO_MENUS_INFO_TEXT", @"");
    }
    
    if (errorString) {
        // show the error label
        [[self errorLabel] setText:errorString];
        [[self errorLabel] setHidden:NO];
        [[self tableView] setHidden:YES];
        
        self.preferredContentSize = self.errorLabel.frame.size;
    } else {
        [[self errorLabel] setHidden:YES];
        [[self tableView] setHidden:NO];
        
        self.preferredContentSize = self.tableView.contentSize;
    }
}

- (Restaurant *)restaurant {
    if (!_restaurant) {
        // check if there's a last restaurant saved
        @try {
            NSUserDefaults *groupUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.StudifutterContainer"];
            NSString *restaurantID = [groupUserDefaults objectForKey:LAST_OPENED_RESTAURANT_ID];
            _restaurant = (Restaurant *)[[FHCoreDataStack sharedStack] managedObjectForID:restaurantID];
            
            // update the title label
            [[self titleLabel] setText:[_restaurant name]];
        }
        @catch (NSException *exception) {
            NSLog(@"Error finding object: %@: %@", [exception name], [exception reason]);
        }
    }
    
    return _restaurant;
}

- (NSArray *)menus {
    if (![self restaurant]) {
        self.preferredContentSize = self.errorLabel.frame.size;
        return nil;
    }
    
    if (!_menus) {
        // this really sucks. the first menu set is the actual MenuSet, the second one is
        // the NSSet of all Menus
        NSDate *today = [NSDate date]; // for weekend testing: [NSDate dateWithTimeIntervalSinceNow:60*60*24*3];
        Restaurant *restaurant = self.restaurant;
        MenuSet *menuSet = [restaurant menuSetForDate:today];
        NSSet *todaysMenuAsASet = menuSet.menuSet;
        _menus = [todaysMenuAsASet allObjects];
    
        self.preferredContentSize = self.tableView.contentSize;
    }
    
    return _menus;
}

#pragma mark - Table view data source & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self menus] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCellIdentifier";
    
    WidgetTableViewCell *cell = (WidgetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WidgetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Menu *menu = [[self menus] objectAtIndex:indexPath.row];
    [cell setMenu:menu];
    
    self.preferredContentSize = self.tableView.contentSize;

    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
