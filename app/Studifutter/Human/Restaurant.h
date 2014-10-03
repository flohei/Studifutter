#import "_Restaurant.h"
#import <MapKit/MapKit.h>

@interface Restaurant : _Restaurant <MKAnnotation> {}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly, copy) NSString *title;

- (NSString *)coreDataID;
- (MenuSet *)menuSetForDate:(NSDate *)date;

@end
