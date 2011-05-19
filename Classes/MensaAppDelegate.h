//
//  MensaAppDelegate.h
//  Mensa
//
//  Created by Florian Heiber on 28.03.09.
//  Copyright rootof.net Florian Heiber & Daniel Wiewel GbR 2009. All rights reserved.
//

@class Meal;
@class InfoPanelViewController;

@interface MensaAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	UITabBarController *tabBarController;
	
	NSMutableString *currentProperty;
	Meal *currentMeal;
	NSMutableArray *parsedArray;
	NSMutableArray *meals;
	
	NSString *dataFilePath;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) NSMutableString *currentProperty;
@property (nonatomic, retain) Meal *currentMeal;
@property (nonatomic, retain) NSMutableArray *parsedArray;
@property (nonatomic, retain) NSMutableArray *meals;

@property (nonatomic, retain) NSString *dataFilePath;

- (BOOL)fetchMeals:(id)sender;
- (void)saveDataInSandbox;
- (BOOL)loadDataFromSandbox;
- (void)showInfo;
- (void)cleanupArray;

@end

