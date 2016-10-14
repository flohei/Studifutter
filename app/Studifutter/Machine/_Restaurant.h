// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Restaurant.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class MenuSet;

@interface RestaurantID : NSManagedObjectID {}
@end

@interface _Restaurant : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RestaurantID *objectID;

@property (nonatomic, strong, nullable) NSString* city;

@property (nonatomic, strong, nullable) NSNumber* closed;

@property (atomic) BOOL closedValue;
- (BOOL)closedValue;
- (void)setClosedValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* latitude;

@property (atomic) double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

@property (nonatomic, strong, nullable) NSNumber* longitude;

@property (atomic) double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

@property (nonatomic, strong, nullable) NSString* menuURL;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* notes;

@property (nonatomic, strong, nullable) NSNumber* restaurantID;

@property (atomic) int32_t restaurantIDValue;
- (int32_t)restaurantIDValue;
- (void)setRestaurantIDValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSString* street;

@property (nonatomic, strong, nullable) NSString* zipCode;

@property (nonatomic, strong, nullable) NSSet<MenuSet*> *menuSet;
- (nullable NSMutableSet<MenuSet*>*)menuSetSet;

@end

@interface _Restaurant (MenuSetCoreDataGeneratedAccessors)
- (void)addMenuSet:(NSSet<MenuSet*>*)value_;
- (void)removeMenuSet:(NSSet<MenuSet*>*)value_;
- (void)addMenuSetObject:(MenuSet*)value_;
- (void)removeMenuSetObject:(MenuSet*)value_;

@end

@interface _Restaurant (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveCity;
- (void)setPrimitiveCity:(nullable NSString*)value;

- (nullable NSNumber*)primitiveClosed;
- (void)setPrimitiveClosed:(nullable NSNumber*)value;

- (BOOL)primitiveClosedValue;
- (void)setPrimitiveClosedValue:(BOOL)value_;

- (nullable NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(nullable NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;

- (nullable NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(nullable NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;

- (nullable NSString*)primitiveMenuURL;
- (void)setPrimitiveMenuURL:(nullable NSString*)value;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSString*)primitiveNotes;
- (void)setPrimitiveNotes:(nullable NSString*)value;

- (nullable NSNumber*)primitiveRestaurantID;
- (void)setPrimitiveRestaurantID:(nullable NSNumber*)value;

- (int32_t)primitiveRestaurantIDValue;
- (void)setPrimitiveRestaurantIDValue:(int32_t)value_;

- (nullable NSString*)primitiveStreet;
- (void)setPrimitiveStreet:(nullable NSString*)value;

- (nullable NSString*)primitiveZipCode;
- (void)setPrimitiveZipCode:(nullable NSString*)value;

- (NSMutableSet<MenuSet*>*)primitiveMenuSet;
- (void)setPrimitiveMenuSet:(NSMutableSet<MenuSet*>*)value;

@end

@interface RestaurantAttributes: NSObject 
+ (NSString *)city;
+ (NSString *)closed;
+ (NSString *)latitude;
+ (NSString *)longitude;
+ (NSString *)menuURL;
+ (NSString *)name;
+ (NSString *)notes;
+ (NSString *)restaurantID;
+ (NSString *)street;
+ (NSString *)zipCode;
@end

@interface RestaurantRelationships: NSObject
+ (NSString *)menuSet;
@end

NS_ASSUME_NONNULL_END
