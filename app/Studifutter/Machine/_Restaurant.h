// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Restaurant.h instead.

#import <CoreData/CoreData.h>

extern const struct RestaurantAttributes {
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *closed;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *menuURL;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *notes;
	__unsafe_unretained NSString *restaurantID;
	__unsafe_unretained NSString *street;
	__unsafe_unretained NSString *zipCode;
} RestaurantAttributes;

extern const struct RestaurantRelationships {
	__unsafe_unretained NSString *menuSet;
} RestaurantRelationships;

@class MenuSet;

@interface RestaurantID : NSManagedObjectID {}
@end

@interface _Restaurant : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RestaurantID* objectID;

@property (nonatomic, strong) NSString* city;

//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* closed;

@property (atomic) BOOL closedValue;
- (BOOL)closedValue;
- (void)setClosedValue:(BOOL)value_;

//- (BOOL)validateClosed:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* latitude;

@property (atomic) double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* longitude;

@property (atomic) double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* menuURL;

//- (BOOL)validateMenuURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* notes;

//- (BOOL)validateNotes:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* restaurantID;

@property (atomic) int32_t restaurantIDValue;
- (int32_t)restaurantIDValue;
- (void)setRestaurantIDValue:(int32_t)value_;

//- (BOOL)validateRestaurantID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* street;

//- (BOOL)validateStreet:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* zipCode;

//- (BOOL)validateZipCode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *menuSet;

- (NSMutableSet*)menuSetSet;

@end

@interface _Restaurant (MenuSetCoreDataGeneratedAccessors)
- (void)addMenuSet:(NSSet*)value_;
- (void)removeMenuSet:(NSSet*)value_;
- (void)addMenuSetObject:(MenuSet*)value_;
- (void)removeMenuSetObject:(MenuSet*)value_;

@end

@interface _Restaurant (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;

- (NSNumber*)primitiveClosed;
- (void)setPrimitiveClosed:(NSNumber*)value;

- (BOOL)primitiveClosedValue;
- (void)setPrimitiveClosedValue:(BOOL)value_;

- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;

- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;

- (NSString*)primitiveMenuURL;
- (void)setPrimitiveMenuURL:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveNotes;
- (void)setPrimitiveNotes:(NSString*)value;

- (NSNumber*)primitiveRestaurantID;
- (void)setPrimitiveRestaurantID:(NSNumber*)value;

- (int32_t)primitiveRestaurantIDValue;
- (void)setPrimitiveRestaurantIDValue:(int32_t)value_;

- (NSString*)primitiveStreet;
- (void)setPrimitiveStreet:(NSString*)value;

- (NSString*)primitiveZipCode;
- (void)setPrimitiveZipCode:(NSString*)value;

- (NSMutableSet*)primitiveMenuSet;
- (void)setPrimitiveMenuSet:(NSMutableSet*)value;

@end
