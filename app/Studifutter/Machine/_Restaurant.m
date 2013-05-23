// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Restaurant.m instead.

#import "_Restaurant.h"

const struct RestaurantAttributes RestaurantAttributes = {
	.city = @"city",
	.closed = @"closed",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.menuURL = @"menuURL",
	.name = @"name",
	.notes = @"notes",
	.restaurantID = @"restaurantID",
	.street = @"street",
	.zipCode = @"zipCode",
};

const struct RestaurantRelationships RestaurantRelationships = {
	.menuSet = @"menuSet",
};

const struct RestaurantFetchedProperties RestaurantFetchedProperties = {
};

@implementation RestaurantID
@end

@implementation _Restaurant

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Restaurant" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Restaurant";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Restaurant" inManagedObjectContext:moc_];
}

- (RestaurantID*)objectID {
	return (RestaurantID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"closedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"closed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"restaurantIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"restaurantID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic city;






@dynamic closed;



- (BOOL)closedValue {
	NSNumber *result = [self closed];
	return [result boolValue];
}

- (void)setClosedValue:(BOOL)value_ {
	[self setClosed:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveClosedValue {
	NSNumber *result = [self primitiveClosed];
	return [result boolValue];
}

- (void)setPrimitiveClosedValue:(BOOL)value_ {
	[self setPrimitiveClosed:[NSNumber numberWithBool:value_]];
}





@dynamic latitude;



- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude;



- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithDouble:value_]];
}





@dynamic menuURL;






@dynamic name;






@dynamic notes;






@dynamic restaurantID;



- (int32_t)restaurantIDValue {
	NSNumber *result = [self restaurantID];
	return [result intValue];
}

- (void)setRestaurantIDValue:(int32_t)value_ {
	[self setRestaurantID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRestaurantIDValue {
	NSNumber *result = [self primitiveRestaurantID];
	return [result intValue];
}

- (void)setPrimitiveRestaurantIDValue:(int32_t)value_ {
	[self setPrimitiveRestaurantID:[NSNumber numberWithInt:value_]];
}





@dynamic street;






@dynamic zipCode;






@dynamic menuSet;

	
- (NSMutableSet*)menuSetSet {
	[self willAccessValueForKey:@"menuSet"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"menuSet"];
  
	[self didAccessValueForKey:@"menuSet"];
	return result;
}
	






@end
