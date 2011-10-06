//
//  DetailViewController.h
//  Mensa
//
//  Created by Florian Heiber on 02.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MealSet;

@interface DetailViewController : UITableViewController {
	MealSet *currentMeal;
}

@property (nonatomic, retain) MealSet *currentMeal;

@end
