// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Menu.m instead.

#import "_Menu.h"

@implementation MenuID
@end

@implementation _Menu

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Menu" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Menu";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Menu" inManagedObjectContext:moc_];
}

- (MenuID*)objectID {
	return (MenuID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"priceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"price"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"reducedPriceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"reducedPrice"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic currency;






@dynamic date;






@dynamic extraChars;






@dynamic extraNumbers;






@dynamic name;






@dynamic price;



- (short)priceValue {
	NSNumber *result = [self price];
	return [result shortValue];
}

- (void)setPriceValue:(short)value_ {
	[self setPrice:[NSNumber numberWithShort:value_]];
}

- (short)primitivePriceValue {
	NSNumber *result = [self primitivePrice];
	return [result shortValue];
}

- (void)setPrimitivePriceValue:(short)value_ {
	[self setPrimitivePrice:[NSNumber numberWithShort:value_]];
}





@dynamic reducedPrice;



- (short)reducedPriceValue {
	NSNumber *result = [self reducedPrice];
	return [result shortValue];
}

- (void)setReducedPriceValue:(short)value_ {
	[self setReducedPrice:[NSNumber numberWithShort:value_]];
}

- (short)primitiveReducedPriceValue {
	NSNumber *result = [self primitiveReducedPrice];
	return [result shortValue];
}

- (void)setPrimitiveReducedPriceValue:(short)value_ {
	[self setPrimitiveReducedPrice:[NSNumber numberWithShort:value_]];
}





@dynamic restaurant;

	





@end
