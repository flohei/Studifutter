//
//  SFActivityProvider.h
//  Studifutter
//
//  Created by Florian Heiber on 28.02.13.
//  Copyright (c) 2013 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuSet;

@interface SFActivityProvider : UIActivityItemProvider <UIActivityItemSource>

@property (nonatomic, strong) MenuSet *menuSet;

@end
