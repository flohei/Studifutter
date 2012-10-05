//
//  SFRestaurantDetailViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFRestaurantDetailViewController.h"
#import "Restaurant.h"
#import "TestFlight.h"
#import <QuartzCore/QuartzCore.h>

@interface SFRestaurantDetailViewController () {
    bool bannerVisible;
}

- (void)moveBannerOffScreen;
- (void)moveBannerOnScreen;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bannerVisibleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHiddenConstraint;

@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipAndCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *postItView;

@end

@implementation SFRestaurantDetailViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    bannerVisible = YES;
    [self moveBannerOffScreen];
    
    self.nameLabel.text = _restaurant.name;
    self.streetLabel.text = _restaurant.street;
    self.zipAndCityLabel.text = [NSString stringWithFormat:@"%@ %@", _restaurant.zipCode, _restaurant.city];
    self.notesLabel.text = _restaurant.notes;
    
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
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setStreetLabel:nil];
    [self setZipAndCityLabel:nil];
    [self setNotesLabel:nil];
    [self setMapView:nil];
    [self setBannerView:nil];
    [self setPostItView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    [TestFlight passCheckpoint:AD_WATCHED_CHECKPOINT];
    return YES;
}


@end
