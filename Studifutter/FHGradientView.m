//
//  FHGradientView.m
//  Studifutter
//
//  Created by Florian Heiber on 17.12.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "FHGradientView.h"
#import "Common.h"
#import <QuartzCore/CoreAnimation.h>

@implementation FHGradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[Common colorWithHex:@"#ff4b4b"] CGColor], (id)[[Common colorWithHex:@"#cc1616"] CGColor], nil];
        [self.layer insertSublayer:gradient atIndex:0];
    }
    return self;
}

@end
