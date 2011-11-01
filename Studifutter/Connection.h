//
//  Connection.h
//  Studifutter
//
//  Created by Florian Heiber on 01.11.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

@interface Connection : NSObject

@property (nonatomic, assign) Reachability *internetReachable;
@property (nonatomic, assign) Reachability *hostReachable;
@property bool internetActive;
@property bool hostActive;

+ (Connection *)sharedConnection;

- (void)checkNetworkStatus:(NSNotification *)notice;

@property (nonatomic, retain) NSManagedObjectContext *context;

@end
