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

@implementation MensaAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize currentProperty;
@synthesize currentMeal;
@synthesize meals;
@synthesize dataFilePath;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"meals.dat"];
	self.dataFilePath = path;
	BOOL mailsFetched = NO;
	
	mailsFetched = [self fetchMeals:self];
	
	if (!mailsFetched) {
		[self loadDataFromSandbox];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
	[self saveDataInSandbox];
}

#pragma mark -
#pragma mark Applications workflow

- (BOOL)fetchMeals:(id)sender {
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
	
		[self saveDataInSandbox];
		
		success = YES;
		NSLog(@"Data successfully loaded from web.");
	}
	@catch (id theException) {
		NSLog(@"%@", theException);
		success = NO;
	}
	
	return success;
}

- (void)saveDataInSandbox {
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:self.meals forKey:@"mealsArray"];
	[encoder finishEncoding];
	
	[theData writeToFile:dataFilePath atomically:YES];
	[encoder release];
}

- (BOOL)loadDataFromSandbox {
	BOOL success;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:dataFilePath]) {
		//open it and read it 
		NSLog(@"data file found. reading into memory");
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
		NSLog(@"no file found. creating empty array");
		success = NO;
	}
	
	return success;
}

#pragma mark -
#pragma mark NSXMLParser delegate methods
/*
 Help for the NSXMLParser found here:
 http://codesofa.com/blog/archive/2008/07/23/make-nsxmlparser-your-friend.html
 */

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

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (self.currentProperty) {
		[self.currentProperty appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (qName) {
		elementName = qName;
	}
	
	if (self.currentMeal) {
		if ([elementName isEqualToString:@"datum"]) {
			// create a proper NSDate object here
			NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
			[formatter setDateStyle:NSDateFormatterShortStyle];
			
			// build a string based on currentProperty and format it like this:
			// mm/dd/yy
			
			NSString *d, *m, *y, *dateString;
			
			d = [currentProperty substringWithRange:NSMakeRange(0, 2)];
			m = [currentProperty substringWithRange:NSMakeRange(3, 2)];
			y = [currentProperty substringWithRange:NSMakeRange(6, 2)];
			
			dateString = m;
			dateString = [dateString stringByAppendingString:@"/"];
			dateString = [dateString stringByAppendingString:d];
			dateString = [dateString stringByAppendingString:@"/"];
			dateString = [dateString stringByAppendingString:y];
		
			NSDate *date = [formatter dateFromString:dateString];
			
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
			[meals addObject:self.currentMeal];
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
	[super dealloc];
}

@end
