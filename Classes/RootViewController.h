//
//  RootViewController.h
//  Mensa
//
//  Created by Florian Heiber on 28.03.09.
//  Copyright rootof.net Florian Heiber & Daniel Wiewel GbR 2009. All rights reserved.
//

@interface RootViewController : UITableViewController <UIAccelerometerDelegate> {
	// Properties for the shaking snippet
	UIAcceleration *lastAcceleration;
	NSInteger shakeCount;
	BOOL notReloadedYet;
}

@property (nonatomic, retain) UIAcceleration *lastAcceleration;
@property (nonatomic) NSInteger shakeCount;
@property (nonatomic) BOOL notReloadedYet;

- (BOOL)AccelerationIsShakingLast:(UIAcceleration *)last current:(UIAcceleration *)current threshold:(double)threshold;

@end
