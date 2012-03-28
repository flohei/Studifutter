//
//  MensaAppDelegate.m
//  Mensa
//
//  Created by Florian Heiber on 28.03.09.
//  Copyright rootof.net Florian Heiber & Daniel Wiewel GbR 2009. All rights reserved.
//

#import "RestaurantAppDelegate.h"
#import "FaveRestaurantListViewController.h"
#import "InfoViewController.h"
#import "MealSet.h"

@implementation RestaurantAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize dataFilePath;
@synthesize restaurantArray;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// manage loading the data
	if (![self loadDataFromSandbox]) {
		NSLog(@"No data found in sandbox.");
	}
	
	navigationController = [[UINavigationController alloc] init];
	FaveRestaurantListViewController *faveRestaurantListViewController = [[FaveRestaurantListViewController alloc] initWithRestaurantArray:restaurantArray];
	[navigationController pushViewController:faveRestaurantListViewController animated:NO];
	[faveRestaurantListViewController release];
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"restaurants.dat"];
	self.dataFilePath = path;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
	[self saveDataInSandbox];
}

#pragma mark -
#pragma mark Applications workflow

// ****************************************************************************************
// 
// ****************************************************************************************
- (void)showInfo {
	RestaurantAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoView" bundle:nil];
	UINavigationController *controller = [appDelegate navigationController];
	
	[controller pushViewController:infoViewController animated:YES];
}

// ****************************************************************************************
// 
// ****************************************************************************************
- (void)saveDataInSandbox {
	if (self.restaurantArray.count > 0) {
		NSMutableData *theData;
		NSKeyedArchiver *encoder;
	
		theData = [NSMutableData data];
		encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
		[encoder encodeObject:self.restaurantArray forKey:@"restaurants"];
		[encoder finishEncoding];
	
		[theData writeToFile:dataFilePath atomically:YES];
		[encoder release];
		NSLog(@"Saved.");
	} else {
		NSLog(@"Not saved because there was nothing to save in the array.");
	}
}

// ****************************************************************************************
// 
// ****************************************************************************************
- (BOOL)loadDataFromSandbox {
	BOOL success;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:dataFilePath]) {
		// open it and read it 
		NSLog(@"Data file found. Reading into memory.");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArray;
		
		theData = [NSData dataWithContentsOfFile:dataFilePath];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"restaurants"];
		self.restaurantArray = tempArray;
		[decoder finishDecoding];
		[decoder release];
		
		success = YES;
		NSLog(@"Data successfully loaded from local file.");
	} else {
		NSLog(@"No file found. Creating empty array.");
		success = NO;
	}
	
	[self saveDataInSandbox];
	
	return success;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[restaurantArray release];
	[dataFilePath release];
	[super dealloc];
}

@end
