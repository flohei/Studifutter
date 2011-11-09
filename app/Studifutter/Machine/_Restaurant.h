// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Restaurant.h instead.

#import <CoreData/CoreData.h>


@class MenuSet;












@interface RestaurantID : NSManagedObjectID {}
@end

@interface _Restaurant : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RestaurantID*)objectID;




@property (nonatomic, retain) NSString *city;


//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *closed;


@property BOOL closedValue;
- (BOOL)closedValue;
- (void)setClosedValue:(BOOL)value_;

//- (BOOL)validateClosed:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *latitude;


@property double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *longitude;


@property double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *menuURL;


//- (BOOL)validateMenuURL:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *notes;


//- (BOOL)validateNotes:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber *restaurantID;


@property int restaurantIDValue;
- (int)restaurantIDValue;
- (void)setRestaurantIDValue:(int)value_;

//- (BOOL)validateRestaurantID:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *street;


//- (BOOL)validateStreet:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *zipCode;


//- (BOOL)validateZipCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSSet* menuSet;

- (NSMutableSet*)menuSetSet;




@end

@interface _Restaurant (CoreDataGeneratedAccessors)

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

- (int)primitiveRestaurantIDValue;
- (void)setPrimitiveRestaurantIDValue:(int)value_;




- (NSString*)primitiveStreet;
- (void)setPrimitiveStreet:(NSString*)value;




- (NSString*)primitiveZipCode;
- (void)setPrimitiveZipCode:(NSString*)value;





- (NSMutableSet*)primitiveMenuSet;
- (void)setPrimitiveMenuSet:(NSMutableSet*)value;


@end
