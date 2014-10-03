#import "Restaurant.h"

@implementation Restaurant

// Custom logic goes here.

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coord;
    coord.longitude = self.longitudeValue;
    coord.latitude = self.latitudeValue;
    return coord;
}

- (NSString *)title {
    return self.name;
}

- (NSString *)subtitle {
    return self.street;
}

- (NSString *)description {
    return self.name;
}

- (NSString *)coreDataID {
    return [[[self objectID] URIRepresentation] absoluteString];
}

- (MenuSet *)menuSetForDate:(NSDate *)date {
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"date == %@", date];
    NSSet *menus = [[self menuSet] filteredSetUsingPredicate:datePredicate];
    MenuSet *menuSet = nil;
    
    // count the items in menus - there should only be one or zero
    if ([menus count] == 1) {
        menuSet = [menus anyObject];
    } else if ([menus count] == 0) {
        // this is the case where there is no menu set for the given date
    } else {
        // this should not happen
    }
    
    return menuSet;
}

@end
