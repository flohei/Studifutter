//
//  XMLParser.m
//  Studifutter
//
//  Created by Florian Heiber on 20.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "XMLParser.h"


@implementation XMLParser
@synthesize currentProperty, currentProperty, parsedArray, meals, success;

#pragma mark -
#pragma mark NSXMLParser delegate methods

// ****************************************************************************************
// 
// ****************************************************************************************
- (NSArray *)fetchMealsWithXMLURL:(NSURL *)xmlURL {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	meals = [[NSMutableArray alloc] init];

	NSURLRequest *request = [NSURLRequest requestWithURL:xmlURL 
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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[theException name] message:[theException reason] delegate:nil cancelButtonTitle:@"Ok…" otherButtonTitles:nil];
		[alert show];
		[alert release];
		success = NO;
	}
	@finally {
		[self cleanupArray];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		return meals;
	}
}

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

@end
