//
//  RestaurantXMLParser.m
//  Studifutter
//
//  Created by Florian Heiber on 28.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "RestaurantXMLParser.h"
#import "Restaurant.h"

@implementation RestaurantXMLParser
@synthesize restaurants, currentRestaurant, currentProperty;

- (NSArray *)fetchRestaurants {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.florian-heiber.de/speiseplan/mensa.asmx/getRestaurants"] 
											 cachePolicy:NSURLRequestReturnCacheDataElseLoad 
										 timeoutInterval:30];
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;

	restaurants = [[NSMutableArray alloc] init];
	
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
		
		if (self.restaurants.count == 0) {
			@throw [NSException exceptionWithName:@"Download failed" reason:@"No data downloaded. Check network connection and try again." userInfo:nil];
		}
	} @catch (id theException) {
		NSLog(@"%@", theException);
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[theException name] message:[theException reason] delegate:nil cancelButtonTitle:@"Ok…" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} @finally {
		return restaurants;
	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// ****************************************************************************************
// Help for the NSXMLParser found here:
// http://codesofa.com/blog/archive/2008/07/23/make-nsxmlparser-your-friend.html
// ****************************************************************************************

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if (qualifiedName) {
		elementName = qualifiedName;
	}
	
	if (self.currentRestaurant) {
		if ([elementName isEqualToString:@"imageURL"] || 
			[elementName isEqualToString:@"name"] || 
			[elementName isEqualToString:@"street"] || 
			[elementName isEqualToString:@"zipcode"] || 
			[elementName isEqualToString:@"city"] || 
			[elementName isEqualToString:@"googleMapsURL"] || 
			[elementName isEqualToString:@"xmlURL"]) {
			self.currentProperty = [NSMutableString string];
		}
	} else {
		if ([elementName isEqualToString:@"Restaurant"]) {
			self.currentRestaurant = [[Restaurant alloc] init];
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
	
	if (self.currentRestaurant) {
		if ([elementName isEqualToString:@"imageURL"]) {
			self.currentRestaurant.image = [UIImage imageWithContentsOfFile:currentProperty];
		}
		else if ([elementName isEqualToString:@"name"]) {
			self.currentRestaurant.name = currentProperty;
		}
		else if ([elementName isEqualToString:@"street"]) {
			self.currentRestaurant.street = currentProperty;
		} 
		else if ([elementName isEqualToString:@"zipcode"]) {
			self.currentRestaurant.zipcode = currentProperty;
		}
		else if ([elementName isEqualToString:@"city"]) {
			self.currentRestaurant.city = currentProperty;
		}
		else if ([elementName isEqualToString:@"googleMapsURL"]) {
			self.currentRestaurant.googleMapsURL = [NSURL URLWithString:currentProperty];
		}
		else if ([elementName isEqualToString:@"xmlURL"]) {
			self.currentRestaurant.xmlURL = [NSURL URLWithString:currentProperty];
		}
		else if ([elementName isEqualToString:@"Restaurant"]) {
			[restaurants addObject:self.currentRestaurant];
			self.currentRestaurant = nil;
		}
	}
	
	self.currentProperty = nil;
}

@end
