// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Menu.h instead.

#import <CoreData/CoreData.h>


extern const struct MenuAttributes {
	__unsafe_unretained NSString *currency;
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *extraChars;
	__unsafe_unretained NSString *extraNumbers;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *reducedPrice;
} MenuAttributes;

extern const struct MenuRelationships {
	__unsafe_unretained NSString *menuSet;
} MenuRelationships;

extern const struct MenuFetchedProperties {
} MenuFetchedProperties;

@class MenuSet;









@interface MenuID : NSManagedObjectID {}
@end

@interface _Menu : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MenuID*)objectID;





@property (nonatomic, strong) NSString* currency;



//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* date;



//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* extraChars;



//- (BOOL)validateExtraChars:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* extraNumbers;



//- (BOOL)validateExtraNumbers:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* price;



@property float priceValue;
- (float)priceValue;
- (void)setPriceValue:(float)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* reducedPrice;



@property float reducedPriceValue;
- (float)reducedPriceValue;
- (void)setReducedPriceValue:(float)value_;

//- (BOOL)validateReducedPrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) MenuSet *menuSet;

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
