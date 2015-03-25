// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MenuSet.h instead.

#import <CoreData/CoreData.h>

extern const struct MenuSetAttributes {
	__unsafe_unretained NSString *date;
} MenuSetAttributes;

extern const struct MenuSetRelationships {
	__unsafe_unretained NSString *menu;
	__unsafe_unretained NSString *restaurant;
} MenuSetRelationships;

@class Menu;
@class Restaurant;

@interface MenuSetID : NSManagedObjectID {}
@end

@interface _MenuSet : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MenuSetID* objectID;

@property (nonatomic, strong) NSDate* date;

//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *menu;

- (NSMutableSet*)menuSet;

@property (nonatomic, strong) Restaurant *restaurant;

//- (BOOL)validateRestaurant:(id*)value_ error:(NSError**)error_;

@end

@interface _MenuSet (MenuCoreDataGeneratedAccessors)
- (void)addMenu:(NSSet*)value_;
- (void)removeMenu:(NSSet*)value_;
- (void)addMenuObject:(Menu*)value_;
- (void)removeMenuObject:(Menu*)value_;

@end

@interface _MenuSet (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;

- (NSMutableSet*)primitiveMenu;
- (void)setPrimitiveMenu:(NSMutableSet*)value;

- (Restaurant*)primitiveRestaurant;
- (void)setPrimitiveRestaurant:(Restaurant*)value;

@end
