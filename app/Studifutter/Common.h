//
//  Common.h
//  axinotecan
//
//  Created by Florian Heiber on 28.06.11.
//  Copyright 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Common : NSObject {
}

+ (UIColor *)colorWithRed:(int)r green:(int)g blue:(int)b;
+ (UIColor *)colorWithHex:(NSString *)hex;
+ (NSDate *)dateWithString:(NSString *)string;

+ (NSString *)md5:(NSString *)str;

@end

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor, BOOL inEllipse);