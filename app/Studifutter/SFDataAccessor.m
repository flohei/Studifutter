//
//  SFDataAccessor.m
//  Studifutter
//
//  Created by Florian Heiber on 03.02.13.
//  Copyright (c) 2013 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFDataAccessor.h"
#import "Restaurant.h"
#import "SFAppDelegate.h"
#import "Studifutter-Swift.h"

@implementation SFDataAccessor

+ (Restaurant *)restaurantByID:(NSNumber *)restaurantID {
    NSArray *restaurants = [SFDataAccessor localRestaurants];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"restaurantID = %@", restaurantID];
    NSArray *filteredRestaurants = [restaurants filteredArrayUsingPredicate:predicate];
    
    if ([filteredRestaurants count] == 1) {
        return (Restaurant *)[filteredRestaurants objectAtIndex:0];
    } else {
        return nil;
    }
}

+ (NSManagedObjectContext *)context {
    SFAppDelegate *appDelegate = (SFAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [[appDelegate coreDataStack] managedObjectContext];
}

+ (NSArray *)localRestaurants {  
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Restaurant" inManagedObjectContext:[self context]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[self context]
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    
    NSError *error;
	if (![theFetchedResultsController performFetch:&error]) {
		// Update to handle the error appropriately.
		//NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    NSArray *fetchedObjects = [theFetchedResultsController fetchedObjects];
    if (!fetchedObjects || [fetchedObjects count] == 0) {
        return nil;
    } else {
        return fetchedObjects;
    }
}

@end
