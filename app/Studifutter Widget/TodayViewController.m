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
#import "Menu.h"
#import "Constants.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

@synthesize restaurant = _restaurant;
@synthesize menus = _menus;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDefaultsDidChange:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.preferredContentSize = self.tableView.contentSize;
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

- (void)userDefaultsDidChange:(NSNotification *)notification {
    _restaurant = nil;
    _menus = nil;
    [[self tableView] reloadData];
}

- (NSString *)monthStringForDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:date];
}

- (Restaurant *)restaurant {
    Restaurant *lastUsedRestaurant = nil;
    // check if there's a last restaurant saved
    @try {
        NSString *restaurantID = [[[NSUserDefaults alloc] initWithSuiteName:@"group.StudifutterContainer"] objectForKey:LAST_OPENED_RESTAURANT_ID];
        lastUsedRestaurant = (Restaurant *)[[FHCoreDataStack sharedStack] managedObjectForID:restaurantID];
    }
    @catch (NSException *exception) {
        NSLog(@"Error finding object: %@: %@", [exception name], [exception reason]);
    }
    
    return lastUsedRestaurant;
}

- (NSArray *)menus {
    if (!_menus) {
        // this really sucks. the first menu set is the actual MenuSet, the second one is
        // the NSSet of all Menus
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        [calendar setTimeZone:timeZone];

        NSDateComponents *testDateComponents = [NSDateComponents new];
        [testDateComponents setYear:2014];
        [testDateComponents setMonth:10];
        [testDateComponents setDay:7];
        
        NSDate *today = [calendar dateFromComponents:testDateComponents]; //[NSDate date];
        Restaurant *restaurant = self.restaurant;
        MenuSet *menuSet = [restaurant menuSetForDate:today];
        NSSet *todaysMenuAsASet = menuSet.menuSet;
        _menus = [todaysMenuAsASet allObjects];
    }
    
    return _menus;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self menus] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DayCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    Menu *menu = [[self menus] objectAtIndex:indexPath.row];
    cell.textLabel.text = [menu name];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

@end
