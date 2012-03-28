#import "_Restaurant.h"
#import <MapKit/MapKit.h>

@interface Restaurant : _Restaurant <MKAnnotation> {}
// Custom logic goes here.

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly, copy) NSString *title;

@end
