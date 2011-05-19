//
//  MensaAppDelegate.m
//  Mensa
//
//  Created by Florian Heiber on 28.03.09.
//  Copyright rootof.net Florian Heiber & Daniel Wiewel GbR 2009. All rights reserved.
//

#import "MensaAppDelegate.h"
#import "RootViewController.h"
#import "Meal.h"
#import "InfoViewController.h"

@implementation MensaAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize tabBarController;
@synthesize currentProperty;
@synthesize currentMeal;
@synthesize parsedArray;
@synthesize meals;
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
			//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Es konnten leider keine Daten geladen werden." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok…"];
			//[alert show];
			//[alert release];
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
- (BOOL)fetchMeals:(id)sender {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	BOOL success;
	meals = [[NSMutableArray alloc] init];
	
	NSString *urlString = @"http://www.florian-heiber.de/speiseplan/mensa.asmx/getSpeiseplanDatumText";
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url 
											 cachePolicy:NSURLRequestReturnCacheDataElseLoad 
										 timeoutInterval:30];
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	parsedArray = [[NSMutableArray alloc] init];
	
	@try {
		urlData = [NSURLConnection sendSynchronousRequest:request 
									returningResponse:&response 
												error:&error];
	
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData:urlData];
		[parser setShouldProcessNamespaces:NO]; // We don't care about namespaces
		[parser setShouldReportNamespacePrefixes:NO]; //
		[parser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
	
		[parser setDelegate:self];
		[parser parse];
	
		[parser release];
		
		if (self.parsedArray.count == 0) {
			@throw [NSException exceptionWithName:@"Download failed" reason:@"No data downloaded. Check network connection and try again." userInfo:nil];
		} else {
			self.meals = parsedArray;
		
			success = YES;
			NSLog(@"Data successfully loaded from web.");
		}
	}
	@catch (id theException) {
		NSLog(@"%@", theException);
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[theException name] message:[theException reason] delegate:nil cancelButtonTitle:@"Ok…" otherButtonTitles:nil];
		//[alert show];
		//[alert release];
		success = NO;
	}
	@finally {
		[self cleanupArray];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		return success;
	}
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

// ****************************************************************************************
// 
// ****************************************************************************************
- (void)cleanupArray {
	// remove old meals
	NSDate *today = [NSDate date];
	// subtract one day (= 86400 seconds) for the today's
	// meals to be displayed
	today = [today addTimeInterval:-86400];
	NSDate *referenceDate, *earlierDate;
	
	NSMutableArray *mealsToRemove = [[NSMutableArray alloc] init];
	
	// mark all the meals to be removed in the array
	for (Meal *m in meals) {
		referenceDate = [m date];
		earlierDate = [referenceDate earlierDate:today];
		
		if (referenceDate == earlierDate) {
			[mealsToRemove addObject:m];
		}
	}
	
	// remove all the items in the new array
	for (Meal *m in mealsToRemove) {
		[meals removeObject:m];
	}
	
	[mealsToRemove release];
}

#pragma mark -
#pragma mark NSXMLParser delegate methods

// ****************************************************************************************
// Help for the NSXMLParser found here:
// http://codesofa.com/blog/archive/2008/07/23/make-nsxmlparser-your-friend.html
// ****************************************************************************************

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if (qualifiedName) {
		elementName = qualifiedName;
	}
	
	if (self.currentMeal) {
		if ([elementName isEqualToString:@"datum"] || [elementName isEqualToString:@"tag"] || [elementName isEqualToString:@"text"]) {
			self.currentProperty = [NSMutableString string];
		}
	} else {
		if ([elementName isEqualToString:@"Speisen"]) {
			self.currentMeal = [[Meal alloc] init];
		}
	}
}

// ****************************************************************************************
// 
// ****************************************************************************************
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (self.currentProperty) {
		[self.currentProperty appendString:string];
	}
}

// ****************************************************************************************
// 
// ****************************************************************************************
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (qName) {
		elementName = qName;
	}
	
	if (self.currentMeal) {
		if ([elementName isEqualToString:@"datum"]) {
			// create a proper NSDate object 
			NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
			[formatter setDateFormat:@"dd.MM.yy"];			
			NSDate *date = [formatter dateFromString:currentProperty];
			
			if (date == nil) {
				NSLog(@"Date not set…");
				NSLog(currentProperty);
			}
			
			self.currentMeal.date = date;
		}
		else if ([elementName isEqualToString:@"tag"]) {
			self.currentMeal.day = currentProperty;
		}
		else if ([elementName isEqualToString:@"text"]) {
			self.currentMeal.text = currentProperty;
		} 
		else if ([elementName isEqualToString:@"Speisen"]) {
			[parsedArray addObject:self.currentMeal];
			self.currentMeal = nil;
		}
	}
	
	self.currentProperty = nil;
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
