//
//  SFMenuViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFMenuViewController.h"
#import "MenuSet.h"
#import "Menu.h"
#import "MenuTableViewCell.h"

@interface SFMenuViewController ()

- (NSArray *)allMenus;

@end

@implementation SFMenuViewController

@synthesize menuSet = _menuSet;
@synthesize swipeGestureRecognizer = _swipeGestureRecognizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self swipeGestureRecognizer] addTarget:self action:@selector(handleSwipeGesture:)];
    [[self swipeGestureRecognizer] setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft)];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Swipe received.");
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCellIdentifier";
    
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Menu *menu = [[self allMenus] objectAtIndex:[indexPath row]];
    
    // Configure the cell...
    [[cell textLabel] setText:[menu name]];
    
    return cell;
}

- (void)viewDidUnload {
    [self setSwipeGestureRecognizer:nil];
    [super viewDidUnload];
}
@end
