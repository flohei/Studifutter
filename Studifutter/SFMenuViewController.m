//
//  SFMenuViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFMenuViewController.h"
#import "SFDayListViewController.h"
#import "Restaurant.h"
#import "MenuSet.h"
#import "Menu.h"
#import "MenuTableViewCell.h"
#import "FHGradientView.h"
#import "PostItView.h"

@interface SFMenuViewController ()

- (NSArray *)allMenus;
- (NSArray *)allMenuSets;

- (void)setupInterface;

@end

@implementation SFMenuViewController

@synthesize menuSet = _menuSet;
@synthesize swipeGestureRecognizer = _swipeGestureRecognizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSwipeGestureRecognizer:[[UISwipeGestureRecognizer alloc] init]];
    [[self swipeGestureRecognizer] addTarget:self action:@selector(handleSwipeLeftGesture:)];
    [[self swipeGestureRecognizer] setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:[self swipeGestureRecognizer]];
    [self setSwipeGestureRecognizer:nil];
    
    [self setSwipeGestureRecognizer:[[UISwipeGestureRecognizer alloc] init]];
    [[self swipeGestureRecognizer] addTarget:self action:@selector(handleSwipeRightGesture:)];
    [[self swipeGestureRecognizer] setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:[self swipeGestureRecognizer]];
    [self setSwipeGestureRecognizer:nil];
    
    [self setupInterface];
}

- (void)setupInterface {
    NSString *restaurantNotes = [[[self menuSet] restaurant] notes];
    if (![restaurantNotes isEqualToString:@""]) {
        UILabel *notesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 160)];
        [notesLabel  setText:restaurantNotes];
        [notesLabel setNumberOfLines:0];
        [notesLabel setLineBreakMode:UILineBreakModeWordWrap];
        [notesLabel setFont:[UIFont systemFontOfSize:10]];
        [notesLabel setBackgroundColor:[UIColor clearColor]];
        [[self tableView] setTableFooterView:notesLabel];
    }
    
    NSDateFormatter *titleDateFormatter = [[NSDateFormatter alloc] init];
    //[titleDateFormatter setDateFormat:@"dd.MM."];
    [titleDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [titleDateFormatter setDoesRelativeDateFormatting:YES];
    
    NSString *dateString = [titleDateFormatter stringFromDate:[[self menuSet] date]];
    [[self navigationItem] setTitle:dateString];
}

- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)recognizer {
    NSArray *allMenus = [self allMenuSets];
    MenuSet *nextMenuSet = nil;
    BOOL currentMenuSetFound = NO;
    
    for (MenuSet *ms in allMenus) {
        if (currentMenuSetFound) {
            nextMenuSet = ms;
            break;
        }
        
        if ([ms isEqual:[self menuSet]]) currentMenuSetFound = YES;
    }
    
    if (nextMenuSet) {
        [self setMenuSet:nextMenuSet];
        [[self tableView] reloadData];
        [self setupInterface];
    }
}

- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer *)recognizer {
    NSArray *allMenus = [self allMenuSets];
    MenuSet *previousMenuSet = nil;
    BOOL currentMenuSetFound = NO;
    
    for (MenuSet *ms in allMenus) {
        if ([ms isEqual:[self menuSet]]) {
            currentMenuSetFound = YES;
            break;
        }
        
        previousMenuSet = ms;
    }
    
    if (currentMenuSetFound && previousMenuSet) {
        [self setMenuSet:previousMenuSet];
        [[self tableView] reloadData];
        [self setupInterface];
    }
}

- (NSArray *)allMenuSets {
    NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSSet *unsortedMenuSet = [[[self menuSet] restaurant] menuSet];
    return [unsortedMenuSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSortDescriptor]];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Misc

- (NSArray *)allMenus {
    return [[[self menuSet] menu] sortedArrayUsingDescriptors:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self allMenus] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCellIdentifier";
    
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    FHGradientView *backgroundView = [[FHGradientView alloc] initWithFrame:[cell bounds]];
    [cell setSelectedBackgroundView:backgroundView];
    
    Menu *menu = [[self allMenus] objectAtIndex:[indexPath row]];
    
    // Configure the cell...
    [cell setMenu:menu];
    
    return cell;
}

- (void)viewDidUnload {
    [self setSwipeGestureRecognizer:nil];
    [super viewDidUnload];
}
@end
