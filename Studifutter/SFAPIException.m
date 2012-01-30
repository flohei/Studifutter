//
//  AXAPIException.m
//  axinotecan
//
//  Created by Florian Heiber on 01.08.11.
//  Copyright 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFAPIException.h"
#import "Constants.h"


@implementation SFAPIException

@synthesize type = _type;
@synthesize NSError = _NSError;

- (id)initWithType:(NSString *)type reason:(NSString *)reason userInfo:(NSDictionary *)userInfo error:(NSError *)error{
	if([reason length] == 0 && error != nil) {
		reason = [error localizedDescription];
	}
    
	if (self = [super initWithName:SF_API_ERROR reason:reason userInfo:userInfo]){
		_type = type;
		_NSError = error;
		return self;
	}
	return nil;
}

- (id)initWithStatusCode:(int)status reason:(NSString *)reason userInfo:(NSDictionary *)userInfo error:(NSError *)error{
	if (reason == nil) switch (status) {
		case SF_API_STATUS_INVALID_CHECKSUM:
		case SF_API_STATUS_UNKNOWN_METHOD:
		case SF_API_STATUS_MISSING_PARAMETER:
			reason = @"Ungültige Anfrage";
			break;
		case SF_API_STATUS_UNKNOWN_ERROR:
		default:
			reason = @"Unbekannter Fehler";
			break;
	}
    
	if (self = [self initWithType:SF_API_ERROR_TYPE_STATUS reason:reason userInfo:userInfo error:error]) {
		_statusCode = status;
		return self;
	}
	return nil;
}

- (int)statusCode{
	return _statusCode;
}

@end
