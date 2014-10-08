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
    bool bannerVisible;
    __weak IBOutlet FHStarButton *favoriteButton;
}

- (void)moveBannerOffScreen;
- (void)moveBannerOnScreen;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bannerVisibleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHiddenConstraint;

@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;

@property CLLocationManager *locationManager;

@end

@implementation SFRestaurantDetailViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    bannerVisible = YES;
    [self moveBannerOffScreen];
    
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Misc

- (void)openAnnotation:(id)annotation; {
    //mv is the mapView
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
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.StudifutterContainer"];
    
    // if the current restaurant is the one already in store remove it
    if (favoriteButton.selected) {
        [sharedDefaults setObject:[NSString string] forKey:LAST_OPENED_RESTAURANT_ID];
    } else {
        // if not store the new restaurant's id
        [sharedDefaults setObject:[[self restaurant] coreDataID] forKey:LAST_OPENED_RESTAURANT_ID];
    }
    
    // write it to disk
    [sharedDefaults synchronize];
    
    // update the buttons selected state
    favoriteButton.selected = !favoriteButton.selected;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"restaurantLocation"];
	annotationView.animatesDrop = YES;
    annotationView.pinColor = MKPinAnnotationColorRed;
    annotationView.canShowCallout = YES;
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    // create a new region and span to show both the user's and the restaurant's location
    [self zoomToFitMapAnnotations:[self mapView]];
}

#pragma mark - iAds

- (NSLayoutConstraint *)bannerHiddenConstraint {
    if (!_bannerHiddenConstraint) {
        _bannerHiddenConstraint = [NSLayoutConstraint constraintWithItem:_bannerView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_containerView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0
                                                                constant:50.0];
    }
    
    return _bannerHiddenConstraint;
}

- (void)moveBannerOffScreen {
    if (!bannerVisible) return;
    
    // layout to starting position
    [_containerView layoutIfNeeded];
    
    [UIView animateWithDuration:.5 animations:^{
        [_containerView removeConstraint:[self bannerVisibleConstraint]];
        [_containerView addConstraint:[self bannerHiddenConstraint]];
        [_containerView layoutIfNeeded];
    }];
    
    bannerVisible = NO;
}

- (void)moveBannerOnScreen {
    if (bannerVisible) return;
    
    // layout to starting position
    [_containerView layoutIfNeeded];
    
    [UIView animateWithDuration:.5 animations:^{
        [_containerView removeConstraint:[self bannerHiddenConstraint]];
        [_containerView addConstraint:[self bannerVisibleConstraint]];
        [_containerView layoutIfNeeded];
    }];
    
    bannerVisible = YES;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self moveBannerOnScreen];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self moveBannerOffScreen];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

@end
