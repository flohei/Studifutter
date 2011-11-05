// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Menu.h instead.

#import <CoreData/CoreData.h>


@class Restaurant;









@interface MenuID : NSManagedObjectID {}
@end

@interface _Menu : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MenuID*)objectID;




@property (nonatomic, retain) NSString *currency;


//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSDate *date;


//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *extraChars;


//- (BOOL)validateExtraChars:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *extraNumbers;


//- (BOOL)validateExtraNumbers:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *price;


@property short priceValue;
- (short)priceValue;
- (void)setPriceValue:(short)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *reducedPrice;


@property short reducedPriceValue;
- (short)reducedPriceValue;
- (void)setReducedPriceValue:(short)value_;

//- (BOOL)validateReducedPrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) Restaurant* restaurant;

//- (BOOL)validateRestaurant:(id*)value_ error:(NSError**)error_;




@end

@interface _Menu (CoreDataGeneratedAccessors)

@end

@interface _Menu (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCurrency;
- (void)setPrimitiveCurrency:(NSString*)value;




- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (NSString*)primitiveExtraChars;
- (void)setPrimitiveExtraChars:(NSString*)value;




- (NSString*)primitiveExtraNumbers;
- (void)setPrimitiveExtraNumbers:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSNumber*)value;

- (short)primitivePriceValue;
- (void)setPrimitivePriceValue:(short)value_;




- (NSNumber*)primitiveReducedPrice;
- (void)setPrimitiveReducedPrice:(NSNumber*)value;

- (short)primitiveReducedPriceValue;
- (void)setPrimitiveReducedPriceValue:(short)value_;





- (Restaurant*)primitiveRestaurant;
- (void)setPrimitiveRestaurant:(Restaurant*)value;


@end
