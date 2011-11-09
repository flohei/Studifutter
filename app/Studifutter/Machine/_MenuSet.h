// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MenuSet.h instead.

#import <CoreData/CoreData.h>


@class Menu;
@class Restaurant;



@interface MenuSetID : NSManagedObjectID {}
@end

@interface _MenuSet : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MenuSetID*)objectID;




@property (nonatomic, retain) NSDate *date;


//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSSet* menu;

- (NSMutableSet*)menuSet;




@property (nonatomic, retain) Restaurant* restaurant;

//- (BOOL)validateRestaurant:(id*)value_ error:(NSError**)error_;




@end

@interface _MenuSet (CoreDataGeneratedAccessors)

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
