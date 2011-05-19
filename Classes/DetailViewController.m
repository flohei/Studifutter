//
//  DetailViewController.m
//  Mensa
//
//  Created by Florian Heiber on 02.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "DetailViewController.h"
#import "Meal.h"
#import "MensaAppDelegate.h"
#import "MultilineTableViewCell.h"

#define kTableViewRowHeight 66

@implementation DetailViewController

@synthesize currentMeal;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	
	self.navigationItem.title = [formatter stringFromDate:currentMeal.date];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Mensa" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
	self.navigationItem.leftBarButtonItem = backButton;
	[backButton release];
}

- (void)done
{
	MensaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	UINavigationController *controller = [appDelegate navigationController];
	
	[controller popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    MultilineTableViewCell *cell = (MultilineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];		
		cell = [[MultilineTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
	NSArray *texts = [currentMeal getMealTexts];
	
	if (indexPath.section == 0) {
		cell.text = [texts objectAtIndex:0];
	}
	else if (indexPath.section == 1) {
		cell.text = [texts objectAtIndex:1];
	}
	else if (indexPath.section == 2) {
		cell.text = [texts objectAtIndex:2];
	}
	
    return cell;
}

/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
		[header setText:@"Heute gibt's:"];
		
		return header;
	}
	return nil;
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kTableViewRowHeight;
}


- (void)dealloc {
	[currentMeal dealloc];
    [super dealloc];
}


@end

