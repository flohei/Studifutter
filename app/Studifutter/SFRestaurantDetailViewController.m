//
//  SFRestaurantDetailViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFRestaurantDetailViewController.h"
#import "Restaurant.h"
#import <QuartzCore/QuartzCore.h>
#import "FHStarButton.h"

@import CoreLocation;

@interface SFRestaurantDetailViewController () {
    __weak IBOutlet FHStarButton *favoriteButton;
}

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property CLLocationManager *locationManager;

@end

@implementation SFRestaurantDetailViewController

BOOL explorationMode = false;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    BOOL showUserLocation = [[NSUserDefaults standardUserDefaults] boolForKey:SHOW_USER_LOCATION];
    if (showUserLocation) {
        // ask the user if the app should show the location
        _locationManager = [[CLLocationManager alloc] init];
        [[self locationManager] requestWhenInUseAuthorization];
        
        // make the map show the user location
        [[self mapView] setShowsUserLocation:YES];
    }
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.003;
    span.longitudeDelta = 0.003;
    
    CLLocationCoordinate2D restaurantLocation;
    restaurantLocation.longitude = [_restaurant.longitude doubleValue];
    restaurantLocation.latitude = [_restaurant.latitude doubleValue];
    
    CLLocationCoordinate2D center;
    center.longitude = restaurantLocation.longitude;
    center.latitude = restaurantLocation.latitude;
    
    region.span = span;
    region.center = center;
    
    [self.mapView setRegion:region];
    [self.mapView regionThatFits:region];
    [self.mapView addAnnotation:self.restaurant];
    
    [self openAnnotation:self.restaurant];
    
    // update the favorite toggle button
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.StudifutterContainer"];
    NSString *storedRestaurantID = [sharedDefaults valueForKey:LAST_OPENED_RESTAURANT_ID];
    [favoriteButton setSelected:[[[self restaurant] coreDataID] isEqualToString:storedRestaurantID]];
    
    // add gesture recognizers for panning and zooming to the map
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(startExploring)];
    panGestureRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:panGestureRecognizer];
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(startExploring)];
    pinchGestureRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:pinchGestureRecognizer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIGestureRecognizers

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}

#pragma mark - Misc

- (void)startExploring {
    if (!explorationMode) {
        explorationMode = true;
    }
    
    // TODO: Add a timer to regularly reset the exploration mode after inactivity
    
//    // Then check if we already have a running timer. If so, invalidate it.
//    if explorationTimer != nil {
//        explorationTimer?.invalidate()
//        explorationTimer = nil
//    }
//    
//    // Create a new exploration timer object.
//    explorationTimer = NSTimer(timeInterval: EXPLORATION_TIME, target: self, selector: #selector(HomeViewController.finishedExploring), userInfo: nil, repeats: false)
//    
//    // Add it to a run loop to start it.
//    let mainRunLoop = NSRunLoop.mainRunLoop()
//    mainRunLoop.addTimer(explorationTimer!, forMode: NSDefaultRunLoopMode)
}

- (void)openAnnotation:(id)annotation {
    [[self mapView] selectAnnotation:annotation animated:YES];
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    // Add a little extra space on the sides
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.5;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.5;
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (IBAction)favoriteToggled:(id)sender {
    // get the app container's user defaults
    NSUserDefaults *groupUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.StudifutterContainer"];
    
    // if the current restaurant is the one already in store remove it
    if (favoriteButton.selected) {
        [groupUserDefaults setObject:[NSString string] forKey:LAST_OPENED_RESTAURANT_ID];
    } else {
        // if not store the new restaurant's id
        [groupUserDefaults setObject:[[self restaurant] coreDataID] forKey:LAST_OPENED_RESTAURANT_ID];
    }
    
    // write it to disk
    [groupUserDefaults synchronize];
    
    // update the buttons selected state
    favoriteButton.selected = !favoriteButton.selected;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"restaurantLocation"];
	annotationView.animatesDrop = YES;
    annotationView.pinTintColor = [UIColor redColor];
    annotationView.canShowCallout = YES;
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!explorationMode) {
        // create a new region and span to show both the user's and the restaurant's location
        [self zoomToFitMapAnnotations:[self mapView]];
    }
}

@end
