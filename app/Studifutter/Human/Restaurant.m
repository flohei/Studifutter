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

@end
