// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MenuSet.m instead.

#import "_MenuSet.h"

const struct MenuSetAttributes MenuSetAttributes = {
	.date = @"date",
};

const struct MenuSetRelationships MenuSetRelationships = {
	.menu = @"menu",
	.restaurant = @"restaurant",
};

@implementation MenuSetID
@end

@implementation _MenuSet

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MenuSet" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MenuSet";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MenuSet" inManagedObjectContext:moc_];
}

- (MenuSetID*)objectID {
	return (MenuSetID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic date;

@dynamic menu;

- (NSMutableSet*)menuSet {
	[self willAccessValueForKey:@"menu"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"menu"];

	[self didAccessValueForKey:@"menu"];
	return result;
}

@dynamic restaurant;

@end

