//
//  NSString+NSString_TrimWhitespace.m
//  Studifutter
//
//  Created by Florian Heiber on 22.03.12.
//  Copyright (c) 2012 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "NSString+TrimWhitespace.h"

@implementation NSString (TrimWhitespace)

- (NSString *)trimWhitespace {
    NSMutableString *mStr = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)mStr);
    
    NSString *result = [mStr copy];

    return result;
}

@end
