//
//  RootViewController.m
//  Mensa
//
//  Created by Florian Heiber on 28.03.09.
//  Copyright rootof.net Florian Heiber & Daniel Wiewel GbR 2009. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "RootViewController.h"
#import "MensaAppDelegate.h"
#import "Meal.h"
#import "MealTableViewCell.h"
#import "DetailViewController.h"
#import "MensaListViewController.h"

@implementation RootViewController
@synthesize shakeCount;
@synthesize lastAcceleration;
@synthesize notReloadedYet;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// add the info button
	UIButton *modalViewButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[modalViewButton addTarget:[[UIApplication sharedApplication] delegate] action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:modalViewButton];
	self.navigationItem.rightBarButtonItem = modalButton;
	[modalViewButton release];
	
	self.navigationItem.title = @"Was futtern?";
	
	notReloadedYet = YES;
	
	[UIAccelerometer sharedAccelerometer].delegate = self;
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0/15)];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark -
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
		cell = [[[MealTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	MensaAppDelegate *appDelegate = (MensaAppDelegate *)[[UIApplication sharedApplication] delegate];
	Meal *m = [appDelegate.meals objectAtIndex:indexPath.row];

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
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MensaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	
	Meal *meal = [[appDelegate meals] objectAtIndex:indexPath.row];
	NSLog(@"Switch to meal: %@", meal);
	
	DetailViewController *detailViewController = [[DetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
	detailViewController.currentMeal = meal;
	
	UINavigationController *controller = [appDelegate navigationController];
	[controller pushViewController:detailViewController animated:YES];
}

#pragma mark -
#pragma mark Shaking Methods

// Method to detect shaking and reset the klick count to zero
// found here: http://stackoverflow.com/questions/150446/how-do-i-detect-when-someone-shakes-an-iphone
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if (self.lastAcceleration) {
        if ([self AccelerationIsShakingLast:self.lastAcceleration current:acceleration threshold:0.7] && shakeCount >= 9) {
			//Shaking here, DO stuff.
			if (notReloadedYet) {
				MensaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
				if ([appDelegate fetchMeals:self]) {
					[self.tableView reloadData];
					NSLog(@"TableView reloaded.");
					// Trigger the vibration
					AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
					notReloadedYet = NO;
			}
			shakeCount = 0;
			}
        } else if ([self AccelerationIsShakingLast:self.lastAcceleration current:acceleration threshold:0.7]) {
			shakeCount = shakeCount + 5;
		} else if (![self AccelerationIsShakingLast:self.lastAcceleration current:acceleration threshold:0.2]) {
			if (shakeCount > 0) {
				shakeCount--;
			}
        }
    }
    self.lastAcceleration = acceleration;
}

- (BOOL) AccelerationIsShakingLast:(UIAcceleration *)last current:(UIAcceleration *)current threshold:(double)threshold {
    double
    deltaX = fabs(last.x - current.x),
    deltaY = fabs(last.y - current.y),
    deltaZ = fabs(last.z - current.z);
	
    return
    (deltaX > threshold && deltaY > threshold) ||
    (deltaX > threshold && deltaZ > threshold) ||
    (deltaY > threshold && deltaZ > threshold);
}

- (void)dealloc {
	[lastAcceleration release];
    [super dealloc];
}

@end
