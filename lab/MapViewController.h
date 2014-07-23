//
//  MapView.h
//  Mensa
//
//  Created by Florian Heiber on 02.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import <MapKit/MapKit.h>

@interface MapViewController : UIView <MKMapViewDelegate> {
	MKMapView *view;
}

@property (nonatomic, retain) MKMapView *view;

@end
