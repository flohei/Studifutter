#import "MenuSet.h"
#import "Menu.h"

@implementation MenuSet

- (NSString *)description {
    return [NSString stringWithFormat:@"MenuSet for day %@ in restaurant %@", [self date], [self restaurant]];
}

- (NSString *)shareText {
    // allocate the mutable string to construct the share string
    NSMutableString *shareText = [NSMutableString string];
    
    // get the right day reference string ('heute', 'morgen', 'übermorgen', 'am xx.xx.')
    [shareText appendFormat:@"%@ ", [self relativeDayReference]];
    
    // add the restaurant
    [shareText appendFormat:@"gibt's in der Mensa (%@) ", [self restaurant]];
    
    // get all the menu items as an array to iterate over them
    NSArray *menuItems = [[self menu] allObjects];
    
    // go through all the items and get their strings
    for (int i = 0; i < [menuItems count]; i++) {
        // get the current item's title
        Menu *menuItem = [menuItems objectAtIndex:i];
        NSString *menuItemTitle = [menuItem name];
        
        // append it
        [shareText appendString:menuItemTitle];
        
        // if it's the second last item add an 'und'. else insert comma.
        if (i == [menuItems count] - 2) {
            [shareText appendString:@" und "];
        } else if (i == [menuItems count] - 1) {
            [shareText appendString:@"."];
        } else {
            [shareText appendString:@", "];
        }
    }
    
    // finish share text
    [shareText appendString:@" Wer kommt mit? :)"];
    
    return shareText;
}

- (NSString *)relativeDayReference {
    NSInteger differenceInDays = [self daysBetweenDate:[NSDate date] andDate:[self date]];
    
    NSString *relativeDayReference = nil;
    switch (differenceInDays) {
        case 0:
            relativeDayReference = @"Heute";
            break;
        case 1:
            relativeDayReference = @"Morgen";
            break;
        case 2:
            relativeDayReference = @"Übermorgen";
            break;
        default: {
            NSDateFormatter *shortDateFormatter = [[NSDateFormatter alloc] init];
            [shortDateFormatter setTimeStyle:NSDateFormatterNoStyle];
            [shortDateFormatter setDateStyle:NSDateFormatterShortStyle];
            
            relativeDayReference = [NSString stringWithFormat:@"Am %@", [shortDateFormatter stringFromDate:[self date]]];
            break;
        }
    }
    
    return relativeDayReference;
}

- (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime {
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

@end
