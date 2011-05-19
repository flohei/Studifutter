//
//  XMLParser.m
//  Studifutter
//
//  Created by Florian Heiber on 20.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "MealXMLParser.h"
#import "RawMeal.h"
#import "MealSet.h"
#import "Meal.h"

@implementation MealXMLParser
@synthesize currentProperty, currentRawMeal, mealSets, rawMeals, success;

#pragma mark -
#pragma mark NSXMLParser delegate methods

// ****************************************************************************************
// 
// ****************************************************************************************
- (NSArray *)fetchMealsWithXMLURL:(NSURL *)xmlURL {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	NSURLRequest *request = [NSURLRequest requestWithURL:xmlURL 
											 cachePolicy:NSURLRequestReturnCacheDataElseLoad 
										 timeoutInterval:30];
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	currentRawMeal = [[RawMeal alloc] init];
	rawMeals = [[NSMutableArray alloc] init];
	
	@try {
		urlData = [NSURLConnection sendSynchronousRequest:request 
										returningResponse:&response 
													error:&error];
		
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData:urlData];
		[parser setShouldProcessNamespaces:NO]; // We don't care about namespaces
		[parser setShouldReportNamespacePrefixes:NO];
		[parser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
		
		[parser setDelegate:self];
		[parser parse];
		
		[parser release];
		
		if (self.rawMeals.count == 0) {
			@throw [NSException exceptionWithName:@"Download failed" reason:@"No data downloaded. Check network connection and try again." userInfo:nil];
		} else {
			// convert the raw meals to a bunch of meal sets here
			for (RawMeal *rm in rawMeals) {
				BOOL mealSetAlreadyCreated = NO;
				for (MealSet *ms in mealSets) {
					if (rm.date == ms.date) {
						Meal *m = [[Meal alloc] init];
						m.title = rm.text;
						m.regularPrice = [self parsePriceString:rm.regularPrice];
						m.specialPrice = [self parsePriceString:rm.specialPrice];
						
						[ms.meals addObject:m];
						[m release];
						mealSetAlreadyCreated = YES;
					}
				}
				
				if (!mealSetAlreadyCreated) {
					MealSet *ms = [[MealSet alloc] init];
					Meal *m = [[Meal alloc] init];
					ms.date = rm.date;
					m.title = rm.text;
					m.regularPrice = [self parsePriceString:rm.regularPrice];
					m.specialPrice = [self parsePriceString:rm.specialPrice];
					
					[ms.meals addObject:m];
					[mealSets addObject:ms];
					[m release];
					[ms release];
				}
			}
			
			success = YES;
			NSLog(@"Data successfully loaded from web.");
		}
	}
	@catch (id theException) {
		NSLog(@"%@", theException);
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[theException name] message:[theException reason] delegate:nil cancelButtonTitle:@"Ok…" otherButtonTitles:nil];
		[alert show];
		[alert release];
		success = NO;
	}
	@finally {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		return mealSets;
	}
}

- (NSNumber *)parsePriceString:(NSString *)prices {
	NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
	[nf setCurrencySymbol:@"€"];
	return [nf numberFromString:prices];
}

// ****************************************************************************************
// Help for the NSXMLParser found here:
// http://codesofa.com/blog/archive/2008/07/23/make-nsxmlparser-your-friend.html
// ****************************************************************************************

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if (qualifiedName) {
		elementName = qualifiedName;
	}
	
	if (self.currentRawMeal) {
		if ([elementName isEqualToString:@"datum"] || [elementName isEqualToString:@"speise"] || [elementName isEqualToString:@"studipreis"] || [elementName isEqualToString:@"normalpreis"]) {
			self.currentProperty = [NSMutableString string];
		}
	} else {
		if ([elementName isEqualToString:@"Futter"]) {
			self.currentRawMeal = [[RawMeal alloc] init];
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
	
	if (self.currentRawMeal) {
		if ([elementName isEqualToString:@"datum"]) {
			// create a proper NSDate object 
			NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
			[formatter setDateFormat:@"dd.MM.yy"];			
			NSDate *date = [formatter dateFromString:currentProperty];
			
			if (date == nil) {
				NSLog(@"Date not set…");
				NSLog(currentProperty);
			}
			
			self.currentRawMeal.date = date;
		}
		else if ([elementName isEqualToString:@"speise"]) {
			self.currentRawMeal.text = currentProperty;
		}
		else if ([elementName isEqualToString:@"studipreis"]) {
			self.currentRawMeal.specialPrice = currentProperty;
		} 
		else if ([elementName isEqualToString:@"normalpreis"]) {
			self.currentRawMeal.regularPrice = currentProperty;
		}
		else if ([elementName isEqualToString:@"Futter"]) {
			[rawMeals addObject:self.currentRawMeal];
			self.currentRawMeal = nil;
		}
	}
	
	self.currentProperty = nil;
}

- (void)dealloc {
	[currentProperty release];
	[currentRawMeal release];
	[rawMeals release];
	[mealSets release];
	[super dealloc];
}	

@end
