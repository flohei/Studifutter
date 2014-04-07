//
//  Common.m
//  axinotecan
//
//  Created by Florian Heiber on 28.06.11.
//  Copyright 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "Common.h"
#import <CommonCrypto/CommonDigest.h>

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, 
                        CGColorRef  endColor, BOOL inEllipse) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, 
                                                        (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    
    if (inEllipse) {
        CGContextAddEllipseInRect(context, rect);
    } else {
        CGContextAddRect(context, rect);
    }
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

int hex2int(const char *hex) {
    int x;
    sscanf(hex, "%x", &x);
    return x;
}

@implementation Common

// returns a UIColor object for RGB-values
+ (UIColor *)colorWithRed:(int)r green:(int)g blue:(int)b {
    float factor =  0.003921;
    float alpha =   1.0;
    
    return [UIColor colorWithRed:r*factor green:g*factor blue:b*factor alpha:alpha];
}

// returns a UIColor based on a hex string of the format #rrggbb
+ (UIColor *)colorWithHex:(NSString *)hex {
    // remove the leading # if there's one
    if ([[hex substringToIndex:1] isEqualToString:@"#"])
        hex = [hex substringFromIndex:1];
    
    NSRange redRange = {0, 2};
    NSRange greenRange = {2, 2};
    NSRange blueRange = {4, 2};
    
    NSString *redHex = [hex substringWithRange:redRange];
    NSString *greenHex = [hex substringWithRange:greenRange];
    NSString *blueHex = [hex substringWithRange:blueRange];
    
    int red = hex2int([redHex cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    int green = hex2int([greenHex cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    int blue = hex2int([blueHex cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    
    return [Common colorWithRed:red green:green blue:blue];
}

+ (NSDate *)dateWithString:(NSString *)string {
    if ([string isEqualToString:@""] || string == nil) return nil;
    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    @try {
        // time zone not support yet
        string = [string substringToIndex:19];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];	
        return [formatter dateFromString:string];
    } @catch (NSException *exception) {
        //NSLog(@"Error parsing date string %@: %@", string, [exception description]);
        return nil;
    }
}

/**
 md5()
 
 returns an MD5 hashed string
 */
+ (NSString *)md5:(NSString *)str {
    if (!str || [str isEqualToString:@""]) return @"";
    
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
	NSString *ret =  [NSString stringWithFormat:
                      @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]
                      ];
	return ret;
}

@end
