//
//  AXAPICall.h
//  axinotecan
//
//  Created by Florian Heiber on 01.08.11.
//  Copyright 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFAPICall : NSObject {
    NSDictionary *_answer;
    
    NSString *_requestPath;
	NSDictionary *_postArgs;
	
	NSString *_checksum;
	NSString *_postString;
	
	BOOL _allowCache;
	NSString *_cacheFilename;
	
	NSMutableData   *_receivedData;
	NSURLConnection *_connection;
	NSURLResponse   *_response;
	NSInteger       _statusCode;
	NSCondition     *_condition;
	NSError         *_error;
    
    BOOL _useJSON;
}

@property BOOL allowCache;
@property BOOL useJSON;

@property (nonatomic, readonly) NSDictionary *answer;

- (id)initWithRequestPath:(NSString *)requestPath postArgs:(NSDictionary *)postArgs getArgs:(NSDictionary *)getArgs;

+ (NSString *)getAPIServerPath;

- (void)call;
+ (NSDictionary *)dictionaryFromRequestPath:(NSString *)requestPath postArgs:(NSDictionary *)postArgs getArgs:(NSDictionary *)getArgs;
+ (NSDictionary *)dictionaryFromRequestPath:(NSString *)requestPath postArgs:(NSDictionary *)postArgs getArgs:(NSDictionary *)getArgs allowCache:(BOOL)allowCache;
+ (NSDictionary *)dictionaryFromRequestPath:(NSString *)requestPath postArgs:(NSDictionary *)postArgs getArgs:(NSDictionary *)getArgs allowCache:(BOOL)allowCache useJSON:(BOOL)useJSON;

@end
