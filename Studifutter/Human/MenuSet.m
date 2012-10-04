#import "MenuSet.h"

@implementation MenuSet

- (NSString *)description {
    return [NSString stringWithFormat:@"MenuSet for day %@ in restaurant %@", [self date], [self restaurant]];
}

@end
