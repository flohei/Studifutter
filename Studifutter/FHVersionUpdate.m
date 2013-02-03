//
//  FHVersionUpdate.m
//  Studifutter
//
//  Created by Florian Heiber on 03.02.13.
//  Copyright (c) 2013 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "FHVersionUpdate.h"
#import "SFAppDelegate.h"

@implementation FHVersionUpdate

+ (NSString *)lastSavedVersion {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:LAST_VERSION];
}

+ (NSString *)currentVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)newerVersion:(NSString *)version1 version2:(NSString *)version2 {    
    // check if one of the versions is nil
    if (version1 == nil) return version2;
    if (version2 == nil) return version1;
    
    // start comparing both version strings by components
    NSArray *versionComponents1 = [version1 componentsSeparatedByString:@"."];
    NSArray *versionComponents2 = [version2 componentsSeparatedByString:@"."];
    
    int numberOfComponents = 0;
    if ([versionComponents1 count] == [versionComponents2 count]) {
        numberOfComponents = [versionComponents1 count];
    } else {
        int count1 = [versionComponents1 count];
        int count2 = [versionComponents2 count];
        
        numberOfComponents = (count1 < count2) ? count1 : count2;
    }
    
    for (int i = 0; i < numberOfComponents; i++) {
        int component1 = [[versionComponents1 objectAtIndex:i] intValue];
        int component2 = [[versionComponents2 objectAtIndex:i] intValue];
        
        if (component1 > component2) {
            return version1;
        } else if (component2 > component1) {
            return version2;
        } else {
            continue;
        }
    }
    
    return nil;
}

+ (BOOL)updateOccured {
    NSString *lastSavedVersion = [FHVersionUpdate lastSavedVersion];
    NSString *currentVersion = [FHVersionUpdate currentVersion];
    
    if ([FHVersionUpdate newerVersion:lastSavedVersion version2:currentVersion] == currentVersion) {
        
        // save the new version
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:LAST_VERSION];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return YES;
    } else {
        return NO;
    }
}

+ (void)handleUpdate {  
    // upate handling: just delete the old stuff and re-download it
    SFAppDelegate *delegate = (SFAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate refreshLocalData];
}

+ (void)checkAndHandleUpdate {
    if ([FHVersionUpdate updateOccured]) {
        [FHVersionUpdate handleUpdate];
    }
}

@end
