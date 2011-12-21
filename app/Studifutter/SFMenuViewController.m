//
//  SFMenuViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFMenuViewController.h"
#import "Restaurant.h"
#import "MenuSet.h"
#import "Menu.h"
#import "MenuTableViewCell.h"
#import "FHGradientView.h"
#import "PostItView.h"

@interface SFMenuViewController ()

- (NSArray *)allMenus;

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
    
    NSString *restaurantNotes = [[[self menuSet] restaurant] notes];
    if (![restaurantNotes isEqualToString:@""]) {
        PostItView *postItView = [[PostItView alloc] initWithFrame:CGRectMake(10, 0, 280, 160)];
        [postItView setPostItText:restaurantNotes];
        [[self tableView] setTableFooterView:postItView];
    }
}

- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Swipe left received.");
}

- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Swipe right received.");
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
