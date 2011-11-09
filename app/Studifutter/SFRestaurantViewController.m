//
//  SFRestaurantViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFRestaurantViewController.h"
#import "SFAppDelegate.h"
#import "Restaurant.h"
#import "Connection.h"
#import "SFDayListViewController.h"
#import "RestaurantTableViewCell.h"


@implementation SFRestaurantViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowDayList"]) {
        SFDayListViewController *dayListViewController = (SFDayListViewController *)[segue destinationViewController];
        dayListViewController.restaurant = [(RestaurantTableViewCell *)sender restaurant];
    } else if ([[segue identifier] isEqualToString:@"ShowInfoView"]) {
        SFInfoViewController *infoViewController = (SFInfoViewController *)[segue destinationViewController];
        infoViewController.delegate = self;
    }
}

#pragma mark - Misc

- (void)dismissInfoView {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - NSFetchedResultsController

- (NSManagedObjectContext *)context {    
    return [(SFAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Restaurant" inManagedObjectContext:[self context]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:self.context sectionNameKeyPath:nil 
                                                   cacheName:@"Restaurant"];
    self.fetchedResultsController = theFetchedResultsController;
    //_fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
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
    return [[[self fetchedResultsController] fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RestaurantCellIdentifier";
    
    RestaurantTableViewCell *cell = (RestaurantTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RestaurantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Restaurant *restaurant = [[[self fetchedResultsController] fetchedObjects] objectAtIndex:[indexPath row]];
    
    // Configure the cell...
    cell.restaurant = restaurant;
    
    return cell;
}

@end
