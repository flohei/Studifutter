//
//  AXAPICall.m
//  axinotecan
//
//  Created by Florian Heiber on 01.08.11.
//  Copyright 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFAPICall.h"
#import "SFAppDelegate.h"
#import "SFAPIException.h"
#import "NSString+URLEncode.h"
#import "Common.h"

@interface SFAPICall ()

- (void)prepareRequestData;
- (void)startSynchronousAPIRequestWithURL:(NSURL *)url;

- (NSString *)doRequest;
- (NSString *)cacheFilename;
+ (NSString *)stringFromArgument:(id)arg argName:(NSString *)argName encode:(BOOL)encode;

- (NSMutableDictionary *)defaultPostArguments;

- (NSDictionary *)dictionaryToStrings:(NSDictionary *)aDictionary;

@end

@implementation SFAPICall

@synthesize allowCache = _allowCache;
@synthesize useJSON = _useJSON;
@synthesize answer = _answer;

#pragma mark - Lifecycle

- (id)initWithRequestPath:(NSString *)requestPath postArgs:(NSDictionary *)postArgs getArgs:(NSDictionary *)getArgs {
    self = [super init];
	if (self) {
        _answer = nil;
		_receivedData = [[NSMutableData alloc] init];
		_condition = [[NSCondition alloc] init];
		_allowCache = YES;
        _useJSON = NO;
		_requestPath = requestPath;
		if (getArgs != nil) {
			for (NSString *key in [getArgs allKeys]) {
				NSRange foundRange = [_requestPath rangeOfString:@"?"];
				id arg = [getArgs objectForKey:key];
				if (arg != nil) {
					arg = [SFAPICall stringFromArgument:arg argName:key encode:YES];
					_requestPath = [NSString stringWithFormat:@"%@%@%@",
                                    _requestPath,
									foundRange.location == NSNotFound ? @"?" : @"&",
									arg];
				}
			}
		}
		
		_postArgs = [self defaultPostArguments];
		if (postArgs != nil) {
			for (NSString *key in [postArgs allKeys]){
				id arg = [postArgs objectForKey:key];
				if (arg != nil){
					[_postArgs setValue:arg forKey:key];
				}
			}
		}
		return self;
	}
	return nil;
}

#pragma mark - Caching

- (NSString *)cacheFilename {
	if (_cacheFilename == nil) {
		[self prepareRequestData];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"apicache"];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if (![fileManager fileExistsAtPath:path]) {
			// Verzeichnis anlegen
			[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
		}
		path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.cache", _checksum]];
		_cacheFilename = path;
	}
	return _cacheFilename;
}

- (BOOL)isCacheAvailable {
	NSString *cacheFilename = [self cacheFilename];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager fileExistsAtPath:cacheFilename];
}

- (NSDictionary *)cachedAnswer {
	NSString *cacheFilename = [self cacheFilename];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:cacheFilename]) {
		return nil;
	}
	
	NSMutableData *theData;
	NSKeyedUnarchiver *decoder;
	NSMutableDictionary *cachedData = [NSMutableDictionary dictionary];
	
	theData = [NSData dataWithContentsOfFile:cacheFilename];
	if (theData) {
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		
		[cachedData setValue:[decoder decodeObjectForKey:@"answer"] forKey:@"answer"];
		[cachedData setValue:[decoder decodeObjectForKey:@"expiration"] forKey:@"expiration"];
		[cachedData setValue:[decoder decodeObjectForKey:@"timestamp"] forKey:@"timestamp"];
		
		[decoder finishDecoding];
		return cachedData;
	}
	else {
		return [NSMutableDictionary dictionary];
	}
}

- (void)saveCache:(NSDictionary *)answer {
	NSString *cacheFilename = [self cacheFilename];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:cacheFilename])
		[fm createFileAtPath:cacheFilename contents:nil attributes:nil];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	int cacheDuration = [[answer objectForKey:@"cachetime"] intValue];
	long now = (long)[[NSDate date] timeIntervalSince1970];
	long expiration = now + cacheDuration;
	
	[encoder encodeObject:answer forKey:@"answer"];
	[encoder encodeObject:[NSNumber numberWithLong:now] forKey:@"timestamp"];
	[encoder encodeObject:[NSNumber numberWithLong:expiration] forKey:@"expiration"];
	[encoder finishEncoding];
	
	[theData writeToFile:cacheFilename atomically:YES];
}

- (void)clearCache {
	NSString *cacheFilename = [self cacheFilename];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error = nil;
	if ([fm fileExistsAtPath:cacheFilename])
		[fm removeItemAtPath:cacheFilename error:&error];
}

#pragma mark - Calling the API

+ (NSDictionary *)dictionaryFromRequestPath:(NSString *)requestPath postArgs:(NSDictionary *)postArgs getArgs:(NSDictionary *)getArgs {
	return [self dictionaryFromRequestPath:requestPath postArgs:postArgs getArgs:getArgs allowCache:YES];
}

+ (NSDictionary *)dictionaryFromRequestPath:(NSString *)requestPath postArgs:(NSDictionary *)postArgs getArgs:(NSDictionary *)getArgs allowCache:(BOOL)allowCache {
	SFAPICall *call = [[SFAPICall alloc] initWithRequestPath:requestPath postArgs:postArgs getArgs:getArgs];
	call.allowCache = allowCache;
	[call call];
    return [call answer];
}

+ (NSDictionary *)dictionaryFromRequestPath:(NSString *)requestPath postArgs:(NSDictionary *)postArgs getArgs:(NSDictionary *)getArgs allowCache:(BOOL)allowCache useJSON:(BOOL)useJSON {
    SFAPICall *call = [[SFAPICall alloc] initWithRequestPath:requestPath postArgs:postArgs getArgs:getArgs];
	call.allowCache = allowCache;
    call.useJSON = useJSON;
	[call call];
    return [call answer];
}

- (void)call {
	// check cache first
	if (_allowCache && [self isCacheAvailable]) {
		NSDictionary *cachedAnswerData = [self cachedAnswer];
		if (cachedAnswerData != nil) {
			long expiration = [[cachedAnswerData objectForKey:@"expiration"] longValue];
			long now = (long)[[NSDate date] timeIntervalSince1970];
			if (expiration > now) {
				NSDictionary *answer = [cachedAnswerData objectForKey:@"answer"];
				if (answer != nil) {
                    _answer = answer;
                    return;
                }
			}
		}
	}
    
	@try {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
		NSString *rawAnswer = [self doRequest];
        NSData *answerData = [rawAnswer dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *jsonError = nil;
		NSDictionary *answer = [NSJSONSerialization JSONObjectWithData:answerData options:NSJSONReadingMutableContainers error:&jsonError];
        
		if (jsonError != nil) {
			//NSLog(@"JSON error: %@ | %@", [jsonError description], rawAnswer);
			SFAPIException *exc = [[SFAPIException alloc] initWithType:SF_API_ERROR_TYPE_JSON reason:nil userInfo:nil error:jsonError];
			@throw exc;
		}
        
		int status = [[answer objectForKey:@"status"] intValue];
        
        // handle the special error cases here
		if (status != SF_API_STATUS_OK) {
			//NSLog(@"API Error Code: %d", status);
			
			SFAPIException *exc = [[SFAPIException alloc] initWithStatusCode:status reason:[answer objectForKey:@"statusmessage"] userInfo:nil error:nil];
			@throw exc;
		}
		
        int cacheDuration = [[answer objectForKey:@"cachetime"] intValue];
		if (_allowCache && cacheDuration > 0) {
			long expiration = (long)[[NSDate date] timeIntervalSince1970] + cacheDuration;
			[answer setValue:[NSNumber numberWithLong:expiration] forKey:@"expiration"];
			[self saveCache:answer];
		} else {
			[self clearCache];
		}
		
        _answer = answer;
	} @catch (NSException * e) {
		// Bei Netzwerkfehler dürfen auch abgelaufene Inhalte aus dem Cache gezogen werden
		if (_allowCache && [self isCacheAvailable]) {
			NSDictionary *cachedAnswerData = [self cachedAnswer];
			if (cachedAnswerData != nil) {
				NSDictionary *answer = [cachedAnswerData objectForKey:@"answer"];
				if (answer != nil) {
                    _answer = answer;
                    return;
                }
			}
		}
        
        @throw e;
	} @finally {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
                     
	return;
}

- (NSString *)doRequest {
	//NSLog(@"Calling API: %@", _requestPath);
	[self prepareRequestData];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self.class getAPIServerPath], _requestPath]];
	
	// Initiate asynchronous URL connection on main thread and block the calling thread
	NSTimeInterval start = CFAbsoluteTimeGetCurrent();
	if (![NSThread isMainThread]) {
		//NSLog(@"Asynchronous API call from background thread");
		[self performSelectorOnMainThread:@selector(startConnectionWithURL:) withObject:url waitUntilDone:YES];
		if (_connection) {
			[_condition lock];
			[_condition wait];
			[_condition unlock];
		} else {
			//NSLog(@"failed to establish a connection for %@", [url absoluteString]);
		}
	} else {
		//NSLog(@"Synchronous API call on main thread");
		[self startSynchronousAPIRequestWithURL:url];
	}
    
	NSTimeInterval delta = (CFAbsoluteTimeGetCurrent() - start);
	NSLog(@"API request on network executed within: %f sec", delta);
    
	if (_error != nil || [_receivedData length] == 0) {
		//NSLog(@"Request error: %@", [_error description]);
		SFAPIException *exc = [[SFAPIException alloc] initWithType:SF_API_ERROR_TYPE_NETWORK reason:nil userInfo:nil error:_error];
		@throw exc;
	}
	
 	// Construct a String around the Data from the response
	NSString *result = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
	// NSLog(@"Raw API answer: %@", result);
	return result;
}

- (void)startConnectionWithURL:(NSURL*)url {
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
															  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
														  timeoutInterval:30];
	[urlRequest setValue:(_useJSON ? @"application/json" : @"application/x-www-form-urlencoded") forHTTPHeaderField:@"content-type"];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[NSData dataWithBytes:[_postString UTF8String] length:[_postString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
	
	// Clean up data from previous session
    [_receivedData setLength:0];
	_error = nil;
	_response = nil;
	
	_connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	//[_connection start];
}

- (void)startSynchronousAPIRequestWithURL:(NSURL *)url {
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
															  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
														  timeoutInterval:30];
	[urlRequest setValue:(_useJSON ? @"application/json" : @"application/x-www-form-urlencoded") forHTTPHeaderField:@"content-type"];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[NSData dataWithBytes:[_postString UTF8String] length:[_postString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
	
	// Clean up data from previous session
    [_receivedData setLength:0];
	_error = nil;
	_response = nil;
    
    NSURLResponse *response;
    NSError *error;
	
	NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    _response = response;
    _error = error;
    
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)_response;
    _statusCode = [httpResponse statusCode];
	if (data) {
		[_receivedData setData:data];
	}
}

#pragma mark - Configuration

- (NSDictionary *)dictionaryToStrings:(NSDictionary *)aDictionary {
    NSMutableString *convertedString = [[NSMutableString alloc] init];
    NSMutableString *checksumString = [[NSMutableString alloc] init];
    
    NSMutableArray *params = [NSMutableArray arrayWithArray:[aDictionary allKeys]];
    [params sortUsingSelector:@selector(compare:)];
    
    for (NSString *s in params) {
        if ([convertedString length] > 0) {
            [convertedString appendString:@"&"];
        }
        
        if ([[aDictionary objectForKey:s] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *subDictionary = [self dictionaryToStrings:[aDictionary objectForKey:s]];
            
            [convertedString appendString:[subDictionary objectForKey:@"postString"]];
            [checksumString appendString:[subDictionary objectForKey:@"checksumString"]];
        } else {
            NSString *argStr = [self.class stringFromArgument:[aDictionary objectForKey:s] argName:s encode:YES];
            [convertedString appendString:argStr];
            argStr = [self.class stringFromArgument:[aDictionary objectForKey:s] argName:s encode:NO];
            [checksumString appendString:argStr];
        }
    }
    
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:convertedString, checksumString, nil] forKeys:[NSArray arrayWithObjects:@"postString", @"checksumString", nil]];
}

- (void)prepareRequestData {
	if (_postString == nil) {
		NSMutableString *postData;
		NSMutableString *checksumData;
		if (_postArgs) {
			// build String with NSDictionary here
			NSDictionary *strings = [self dictionaryToStrings:_postArgs];
            postData = [strings objectForKey:@"postString"];
            checksumData = [strings objectForKey:@"checksumString"];
		} else {
            return;
        }
		
		// calculate md5 and append as postfield
		NSString *stringToChecksum = [NSString stringWithFormat:@"%@%@%s", 
                                      _requestPath,
                                      checksumData,
                                      API_SECRET];
		if ([postData length] > 0) {
			[postData appendString:@"&"];
		}
        
        //NSLog(@"stringToChecksum: %@", stringToChecksum);
		_checksum = [Common md5:stringToChecksum];
        //NSLog(@"checksum: %@", _checksum);
		[postData appendFormat:@"checksum=%@", _checksum];
        
        if (!_useJSON) {
            _postString = [NSString stringWithString:postData];
        } else {
            NSMutableDictionary *JSONDictionary = [NSMutableDictionary dictionaryWithDictionary:_postArgs];
            [JSONDictionary setObject:_checksum forKey:@"checksum"];
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSONDictionary
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:&error];
            if (!jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                _postString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
        }
    }
}

- (NSMutableDictionary *)defaultPostArguments {
	NSMutableDictionary *defaultArgs = [NSMutableDictionary dictionary];
	NSString *userAgent = [NSString stringWithFormat:@"%@(%@;%@)", 
						   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
						   [[UIDevice currentDevice] systemVersion], 
						   [[UIDevice currentDevice] model]];
	
	[defaultArgs setObject:[[UIDevice currentDevice] systemName] forKey:@"AppID"];
	[defaultArgs setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] forKey:@"AppVersion"];
	[defaultArgs setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UUID_KEY] forKey:@"ClientID"];
	[defaultArgs setObject:userAgent forKey:@"UserAgent"];
	
	return defaultArgs;
}

+ (NSString *)stringFromArgument:(id)arg argName:(NSString *)argName encode:(BOOL)encode {
    // check what kind of attribute we're talking about and handle it appropriately
	
    if ([arg isKindOfClass:NSArray.class]) {
        // are you an array?
        
		NSString *argStr = [NSString string];
		for (id argValue in arg) {
            NSMutableString *argumentStringValue;
            
            if ([argValue isKindOfClass:[NSDictionary class]]) {
                // this happens when there is an array that contains new 
                // dictinoaries
                
                NSArray *keys = [(NSDictionary *)argValue allKeys];
                argumentStringValue = [[NSMutableString alloc] init];
                
                for (NSString *s in keys) {
                    [argumentStringValue appendString:[SFAPICall stringFromArgument:[(NSDictionary *)argValue objectForKey:s] argName:s encode:encode]];;
                }
            }
			else if (![argValue isKindOfClass:[NSString class]]) {
                argumentStringValue = [[NSMutableString alloc] initWithString:[argValue stringValue]];
            }
			
            argStr = [NSString stringWithFormat:@"%@%@%@[]=%@",
					  argStr,
					  encode && ([argStr length]) > 0 ? @"&" : @"",
					  encode ? [argName URLEncoded] : argName,
					  encode ? [argumentStringValue URLEncoded] : argumentStringValue
					  ];
		}
		return argStr;
        
    } else if ([arg isKindOfClass:[NSDate class]]) {
        // are you a date?
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.MM.yyyy"];
        NSString *dateString = [formatter stringFromDate:(NSDate *)arg];
        
        return [NSString stringWithFormat:@"%@=%@", encode ? [argName URLEncoded] : argName, dateString];
        
	} else if ([arg isKindOfClass:[NSDictionary class]]) {
        // are you a dictionary?
        
        for (NSString *key in [(NSDictionary *)arg allKeys]) {
            
        }
        
    } else if (![arg isKindOfClass:NSString.class]) {
        // are you an ordinary string?
        
		return [NSString stringWithFormat:@"%@=%@", encode ? [argName URLEncoded] : argName, [arg stringValue]];
	}
	return [NSString stringWithFormat:@"%@=%@", encode ? [argName URLEncoded] : argName, encode ? [arg URLEncoded] : arg];
}

#pragma mark - Helper methods

+ (NSString *)getAPIServerPath {
	if (API_LIVE_SERVER) {
		return API_SERVER_PATH_LIVE;
	} else {
		return API_SERVER_PATH_TEST;
	}
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// Store the response and retrieve HTTP status code
	_response = response;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    _statusCode = [httpResponse statusCode];
	
	//NSLog(@"HTTP response with status code %d", _statusCode);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	//NSLog(@"API response: appending %d bytes", [data length]);
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	//NSLog(@"API response completely received");
	_connection = nil;
	
	// Signal the condition
	[_condition lock];
	[_condition signal];
	[_condition unlock];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//NSLog(@"API response error");
    _error = [error copy];
	_connection = nil;
	
	// Signal the condition
	[_condition lock];
	[_condition signal];
	[_condition unlock];
}

@end
