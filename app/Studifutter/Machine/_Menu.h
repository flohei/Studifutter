// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Menu.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class MenuSet;

@interface MenuID : NSManagedObjectID {}
@end

@interface _Menu : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MenuID *objectID;

@property (nonatomic, strong, nullable) NSString* currency;

@property (nonatomic, strong, nullable) NSDate* date;

@property (nonatomic, strong, nullable) NSString* extraChars;

@property (nonatomic, strong, nullable) NSString* extraNumbers;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSNumber* price;

@property (atomic) float priceValue;
- (float)priceValue;
- (void)setPriceValue:(float)value_;

@property (nonatomic, strong, nullable) NSNumber* reducedPrice;

@property (atomic) float reducedPriceValue;
- (float)reducedPriceValue;
- (void)setReducedPriceValue:(float)value_;

@property (nonatomic, strong, nullable) MenuSet *menuSet;

@end

@interface _Menu (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveCurrency;
- (void)setPrimitiveCurrency:(nullable NSString*)value;

- (nullable NSDate*)primitiveDate;
- (void)setPrimitiveDate:(nullable NSDate*)value;

- (nullable NSString*)primitiveExtraChars;
- (void)setPrimitiveExtraChars:(nullable NSString*)value;

- (nullable NSString*)primitiveExtraNumbers;
- (void)setPrimitiveExtraNumbers:(nullable NSString*)value;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(nullable NSNumber*)value;

- (float)primitivePriceValue;
- (void)setPrimitivePriceValue:(float)value_;

- (nullable NSNumber*)primitiveReducedPrice;
- (void)setPrimitiveReducedPrice:(nullable NSNumber*)value;

- (float)primitiveReducedPriceValue;
- (void)setPrimitiveReducedPriceValue:(float)value_;

- (MenuSet*)primitiveMenuSet;
- (void)setPrimitiveMenuSet:(MenuSet*)value;

@end

@interface MenuAttributes: NSObject 
+ (NSString *)currency;
+ (NSString *)date;
+ (NSString *)extraChars;
+ (NSString *)extraNumbers;
+ (NSString *)name;
+ (NSString *)price;
+ (NSString *)reducedPrice;
@end

@interface MenuRelationships: NSObject
+ (NSString *)menuSet;
@end

NS_ASSUME_NONNULL_END
