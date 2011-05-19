//
//  MultilineTableViewCell.h
//  Mensa
//
//  Created by Florian Heiber on 03.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MultilineTableViewCell : UITableViewCell {
	UILabel *label;
}

@property (nonatomic, retain) UILabel *label;

@end
