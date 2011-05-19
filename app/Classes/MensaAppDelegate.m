//
//  MensaAppDelegate.m
//  Mensa
//
//  Created by Florian Heiber on 28.03.09.
//  Copyright rootof.net Florian Heiber & Daniel Wiewel GbR 2009. All rights reserved.
//

#import "MensaAppDelegate.h"
#import "RootViewController.h"
#import "MealSet.h"
#import "InfoViewController.h"

@implementation MensaAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize tabBarController;
@synthesize dataFilePath;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Override point for customization after app launch
	[window addSubview:[tabBarController view]];
	[window addSubview:[navigationController view]];
	
    [window makeKeyAndVisible];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"meals.dat"];
	self.dataFilePath = path;
	
	// manage loading the data
	if (![self loadDataFromSandbox]) {
		if (![self fetchMeals:self]) {
			NSLog(@"No data found. Neither locally nor online.");
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Es konnten leider keine Daten geladen werden." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok…"];
			[alert show];
			[alert release];
		}
	}
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
	MensaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoView" bundle:nil];
	UINavigationController *controller = [appDelegate navigationController];
	
	[controller pushViewController:infoViewController animated:YES];
}

// ****************************************************************************************
// 
// ****************************************************************************************
- (void)saveDataInSandbox {
	if (self.meals.count > 0) {
		NSMutableData *theData;
		NSKeyedArchiver *encoder;
	
		theData = [NSMutableData data];
		encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
		[encoder encodeObject:self.meals forKey:@"mealsArray"];
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
		tempArray = [decoder decodeObjectForKey:@"mealsArray"];
		self.meals = tempArray;
		[decoder finishDecoding];
		[decoder release];
		
		success = YES;
		NSLog(@"Data successfully loaded from local file.");
	} else {
		NSLog(@"No file found. Creating empty array.");
		success = NO;
	}

	// check if there are enough meals left
	// if not, load new ones from the web
	if (self.meals.count < 5) {
		NSLog(@"Fetch meals because there are not enough in the array.");
		[self fetchMeals:self];
	}
	
	[self cleanupArray];
	
	[self saveDataInSandbox];
	
	return success;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[tabBarController release];
	[currentProperty release];
	[currentMeal release];
	[meals release];
	[parsedArray release];
	[dataFilePath release];
	[super dealloc];
}

@end
