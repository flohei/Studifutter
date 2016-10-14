// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Menu.m instead.

#import "_Menu.h"

@implementation MenuID
@end

@implementation _Menu

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"priceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"price"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"reducedPriceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"reducedPrice"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic currency;

@dynamic date;

@dynamic extraChars;

@dynamic extraNumbers;

@dynamic name;

@dynamic price;

- (float)priceValue {
	NSNumber *result = [self price];
	return [result floatValue];
}

- (void)setPriceValue:(float)value_ {
	[self setPrice:@(value_)];
}

- (float)primitivePriceValue {
	NSNumber *result = [self primitivePrice];
	return [result floatValue];
}

- (void)setPrimitivePriceValue:(float)value_ {
	[self setPrimitivePrice:@(value_)];
}

@dynamic reducedPrice;

- (float)reducedPriceValue {
	NSNumber *result = [self reducedPrice];
	return [result floatValue];
}

- (void)setReducedPriceValue:(float)value_ {
	[self setReducedPrice:@(value_)];
}

- (float)primitiveReducedPriceValue {
	NSNumber *result = [self primitiveReducedPrice];
	return [result floatValue];
}

- (void)setPrimitiveReducedPriceValue:(float)value_ {
	[self setPrimitiveReducedPrice:@(value_)];
}

@dynamic menuSet;

@end

@implementation MenuAttributes 
+ (NSString *)currency {
	return @"currency";
}
+ (NSString *)date {
	return @"date";
}
+ (NSString *)extraChars {
	return @"extraChars";
}
+ (NSString *)extraNumbers {
	return @"extraNumbers";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)price {
	return @"price";
}
+ (NSString *)reducedPrice {
	return @"reducedPrice";
}
@end

@implementation MenuRelationships 
+ (NSString *)menuSet {
	return @"menuSet";
}
@end

