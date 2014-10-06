//
//  FHStarButton.m
//  Studifutter
//
//  Created by Florian Heiber on 06/10/14.
//  Copyright (c) 2014 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "FHStarButton.h"

@implementation FHStarButton

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //// Color Declarations
    UIColor* borderColor = [UIColor colorWithRed: 1 green: 0 blue: 0 alpha: 1];
    UIColor* selectionColor = [UIColor colorWithRed: 1 green: 1 blue: 0.114 alpha: 1];
    UIColor* clearColor = [UIColor clearColor];
    
    //// FavoriteStar Drawing
    UIBezierPath* favoriteStarPath = [UIBezierPath bezierPath];
    [favoriteStarPath moveToPoint: CGPointMake(15.5, 3)];
    [favoriteStarPath addLineToPoint: CGPointMake(19.91, 9.69)];
    [favoriteStarPath addLineToPoint: CGPointMake(27.39, 11.98)];
    [favoriteStarPath addLineToPoint: CGPointMake(22.63, 18.41)];
    [favoriteStarPath addLineToPoint: CGPointMake(22.85, 26.52)];
    [favoriteStarPath addLineToPoint: CGPointMake(15.5, 23.8)];
    [favoriteStarPath addLineToPoint: CGPointMake(8.15, 26.52)];
    [favoriteStarPath addLineToPoint: CGPointMake(8.37, 18.41)];
    [favoriteStarPath addLineToPoint: CGPointMake(3.61, 11.98)];
    [favoriteStarPath addLineToPoint: CGPointMake(11.09, 9.69)];
    [favoriteStarPath closePath];
    
    if (self.state == UIControlStateSelected) {
        [selectionColor setFill];
    } else {
        [clearColor setFill];
    }
    
    [favoriteStarPath fill];
    [borderColor setStroke];
    favoriteStarPath.lineWidth = 2;
    [favoriteStarPath stroke];
}

@end
