//
//  MealTableViewCell.h
//  Mensa
//
//  Created by Florian Heiber on 01.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MealTableViewCell : UITableViewCell {
	UILabel *dateLabel;
	UILabel *textLabel;
}

// gets the data from another class
-(void)setData:(NSDictionary *)dict;

// internal function to ease setting up label text
-(UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

// you should know what this is for by know
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *textLabel;

@end
