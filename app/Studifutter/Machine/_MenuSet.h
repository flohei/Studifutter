// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MenuSet.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Menu;
@class Restaurant;

@interface MenuSetID : NSManagedObjectID {}
@end

@interface _MenuSet : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MenuSetID *objectID;

@property (nonatomic, strong, nullable) NSDate* date;

@property (nonatomic, strong, nullable) NSSet<Menu*> *menu;
- (nullable NSMutableSet<Menu*>*)menuSet;

@property (nonatomic, strong, nullable) Restaurant *restaurant;

@end

@interface _MenuSet (MenuCoreDataGeneratedAccessors)
- (void)addMenu:(NSSet<Menu*>*)value_;
- (void)removeMenu:(NSSet<Menu*>*)value_;
- (void)addMenuObject:(Menu*)value_;
- (void)removeMenuObject:(Menu*)value_;

@end

@interface _MenuSet (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSDate*)primitiveDate;
- (void)setPrimitiveDate:(nullable NSDate*)value;

- (NSMutableSet<Menu*>*)primitiveMenu;
- (void)setPrimitiveMenu:(NSMutableSet<Menu*>*)value;

- (Restaurant*)primitiveRestaurant;
- (void)setPrimitiveRestaurant:(Restaurant*)value;

@end

@interface MenuSetAttributes: NSObject 
+ (NSString *)date;
@end

@interface MenuSetRelationships: NSObject
+ (NSString *)menu;
+ (NSString *)restaurant;
@end

NS_ASSUME_NONNULL_END
