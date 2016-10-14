// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MenuSet.m instead.

#import "_MenuSet.h"

@implementation MenuSetID
@end

@implementation _MenuSet

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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

- (NSMutableSet<Menu*>*)menuSet {
	[self willAccessValueForKey:@"menu"];

	NSMutableSet<Menu*> *result = (NSMutableSet<Menu*>*)[self mutableSetValueForKey:@"menu"];

	[self didAccessValueForKey:@"menu"];
	return result;
}

@dynamic restaurant;

@end

@implementation MenuSetAttributes 
+ (NSString *)date {
	return @"date";
}
@end

@implementation MenuSetRelationships 
+ (NSString *)menu {
	return @"menu";
}
+ (NSString *)restaurant {
	return @"restaurant";
}
@end

