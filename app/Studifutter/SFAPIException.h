//
//  AXAPIException.h
//  axinotecan
//
//  Created by Florian Heiber on 01.08.11.
//  Copyright 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"


@interface SFAPIException : NSException {
    NSString *_type;
	int _statusCode;
	NSError *_NSError;
}

@property (readonly) NSString *type;
@property (readonly) int statusCode;
@property (readonly) NSError *NSError;

- (id)initWithType:(NSString *)type reason:(NSString *)reason userInfo:(NSDictionary *)userInfo error:(NSError *)error;
- (id)initWithStatusCode:(int)status reason:(NSString *)reason userInfo:(NSDictionary *)userInfo error:(NSError *)error;

@end
