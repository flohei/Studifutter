//
//  RootViewController.m
//  Mensa
//
//  Created by Florian Heiber on 28.03.09.
//  Copyright rootof.net Florian Heiber & Daniel Wiewel GbR 2009. All rights reserved.
//

#import "RootViewController.h"
#import "MensaAppDelegate.h"
#import "Meal.h"
#import "MealTableViewCell.h"
#import "DetailViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//MensaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	//[appDelegate fetchMeals:self];
	
	UIButton *modalViewButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[modalViewButton addTarget:self action:@selector(infoButtonClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:modalViewButton];
	self.navigationItem.rightBarButtonItem = modalButton;
	[modalViewButton release];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)infoButtonClick
{
	NSLog(@"Show info panel here…");
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MensaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	return appDelegate.meals.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    MealTableViewCell *cell = (MealTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		// for 3.0
        // cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		// for 2.2.1
		cell = [[[MealTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	Meal *m;
	MensaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	m = [[appDelegate meals] objectAtIndex:indexPath.row];
	
	NSMutableArray *values = [[NSMutableArray alloc] init];
	[values addObject:m.date];
	[values addObject:m.text];
	
	NSMutableArray *keys = [[NSMutableArray alloc] init];
	[keys addObject:@"date"];
	[keys addObject:@"text"];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
	[cell setData:dict];
	
	[values release];
	[keys release];

    return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Navigation logic may go here -- for example, create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController animated:YES];
	// [anotherViewController release];
	MensaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	Meal *meal = [[appDelegate meals] objectAtIndex:indexPath.row];
	NSLog(@"Switch to meal: %@", meal);
	
	DetailViewController *detailViewController = [[DetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
	detailViewController.currentMeal = meal;
	
	UINavigationController *controller = [appDelegate navigationController];
	[controller pushViewController:detailViewController animated:YES];
}

// The accessory type is the image displayed on the far right of each table cell. In order for the delegate method
// tableView:accessoryButtonClickedForRowWithIndexPath: to be called, you must return the "Detail Disclosure Button" type.
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)dealloc {
    [super dealloc];
}


@end

