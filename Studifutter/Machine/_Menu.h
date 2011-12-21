// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Menu.h instead.

#import <CoreData/CoreData.h>


@class MenuSet;









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


@property float priceValue;
- (float)priceValue;
- (void)setPriceValue:(float)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *reducedPrice;


@property float reducedPriceValue;
- (float)reducedPriceValue;
- (void)setReducedPriceValue:(float)value_;

//- (BOOL)validateReducedPrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) MenuSet* menuSet;

//- (BOOL)validateMenuSet:(id*)value_ error:(NSError**)error_;




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

- (float)primitivePriceValue;
- (void)setPrimitivePriceValue:(float)value_;




- (NSNumber*)primitiveReducedPrice;
- (void)setPrimitiveReducedPrice:(NSNumber*)value;

- (float)primitiveReducedPriceValue;
- (void)setPrimitiveReducedPriceValue:(float)value_;





- (MenuSet*)primitiveMenuSet;
- (void)setPrimitiveMenuSet:(MenuSet*)value;


@end
