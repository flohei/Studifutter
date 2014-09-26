#import "MenuSet.h"
#import "Menu.h"

@implementation MenuSet

- (NSString *)description {
    return [NSString stringWithFormat:@"MenuSet for day %@ in restaurant %@", [self date], [self restaurant]];
}

- (NSString *)shareTextTwitter {
    NSMutableString *shareText = [NSMutableString string];
    [shareText appendFormat:@"%@ bin ich in der Mensa (%@). Wer kommt mit? /via @studifutter", [self relativeDayReference], [self restaurant]];
    return [self stripDoubleSpaceFrom:shareText];
}

- (NSString *)shareTextMail {
    NSMutableString *shareText = [NSMutableString string];
    [shareText appendString:@"Hi Freund,\n\n"];
    [shareText appendString:[self longShareTextBase]];
    [shareText appendString:@" Kommst du mit?\n\n"];
    [shareText appendString:@"Via Studifutter (http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=313502627&mt=8)"];
    return [self stripDoubleSpaceFrom:shareText];
}

- (NSString *)shareTextFacebook {    
    return [NSString stringWithFormat:@"%@ Wer kommt mit? :)", [self longShareTextBase]];
}

- (NSString *)longShareTextBase {
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
    
    return [self stripDoubleSpaceFrom:shareText];
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
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

- (NSString *)stripDoubleSpaceFrom:(NSString *)str {
    while ([str rangeOfString:@"  "].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return str;
}

@end
