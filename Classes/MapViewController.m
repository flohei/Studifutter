//
//  MapView.m
//  Mensa
//
//  Created by Florian Heiber on 02.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "MapViewController.h"
//#import "MensaAnnotation.h"
#import <MapKit/MapKit.h>

@implementation MapViewController
@synthesize view;

- (id)initWithFrame:(CGRect)frame {
	NSLog(@"initWithFrame:");
	
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		[self addSubview:view];
    }
    return self;
}

/*- (void)loadView {
	MKMapView *mv = [[MKMapView alloc] init];
    mv.frame = [[UIScreen mainScreen] applicationFrame];
	
    CLLocationCoordinate2D center;
    center.latitude = 37.33168900;
    center.longitude = -122.03073100;
	
    MKCoordinateRegion region;
    region.center = center;
    region.span.latitudeDelta = 0.1;
    region.span.longitudeDelta = 0.1;
    mv.region = region;
	
    mv.delegate = self;
	
    MensaAnnotation *ann = [[MensaAnnotation alloc] initWithCoordinate:center];
    [mv addAnnotation:ann];
    [ann release];
	
    [self addSubview:mv];
    [mv release];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *defaultPinID = @"DefaultPinID";
	
    MKAnnotationView *mkav = [mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (mkav == nil) {
        mkav = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
    }
	
    return mkav;
}*/

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	[view dealloc];
    [super dealloc];
}


@end
