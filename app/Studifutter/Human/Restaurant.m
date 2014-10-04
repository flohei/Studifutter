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
    // clean the date first, we only need the date itself, not the time
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    NSDateComponents *daysComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSDate *cleanedDate = [calendar dateFromComponents:daysComponents];
    
    // create another date for a one day span
    NSDateComponents *oneDay = [NSDateComponents new];
    [oneDay setDay:1];
    NSDate *cleanedDateEnd = [calendar dateByAddingComponents:oneDay toDate:cleanedDate options:0];
    
    // check for that one day span
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", cleanedDate, cleanedDateEnd];
    
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
