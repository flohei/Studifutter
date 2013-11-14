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

@interface SFRestaurantDetailViewController () {
    bool bannerVisible;
}

- (void)moveBannerOffScreen;
- (void)moveBannerOnScreen;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bannerVisibleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHiddenConstraint;

@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;

@end

@implementation SFRestaurantDetailViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    bannerVisible = YES;
    [self moveBannerOffScreen];
    
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

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"restaurantLocation"];
	annotationView.animatesDrop = YES;
    annotationView.pinColor = MKPinAnnotationColorRed;
    annotationView.canShowCallout = YES;
	return annotationView;
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
