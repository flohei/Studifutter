//
//  MensaAppDelegate.h
//  Mensa
//
//  Created by Florian Heiber on 28.03.09.
//  Copyright rootof.net Florian Heiber & Daniel Wiewel GbR 2009. All rights reserved.
//

@class InfoPanelViewController;

@interface MensaAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
	UITabBarController *tabBarController;
	
	NSString *dataFilePath;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) NSString *dataFilePath;

- (void)saveDataInSandbox;
- (BOOL)loadDataFromSandbox;
- (void)showInfo;

@end

