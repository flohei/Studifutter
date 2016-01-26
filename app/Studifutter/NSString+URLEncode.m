//
//  NSString+urlencode.m
//  axinotecan
//
//  Created by Florian Heiber on 29.08.2011.
//  Copyright 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "NSString+URLEncode.h"


@implementation NSString (URLEncode)

- (NSString *)URLEncoded {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet alloc] init]];
}

@end
