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

@interface SFRestaurantDetailViewController ()

- (void)moveBannerOffScreen;
- (void)moveBannerOnScreen;

@end

@implementation SFRestaurantDetailViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    bannerVisible = YES;
    [self moveBannerOnScreen];
    
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
    [self setStreetLabel:nil];
    [self setZipAndCityLabel:nil];
    [self setNotesLabel:nil];
    [self setMapView:nil];
    [self setBannerView:nil];
    [self setPostItView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (void)moveBannerOffScreen {   
    if (!bannerVisible) return;
    
    float offset = self.bannerView.frame.size.height;
    
    CGRect bannerFrame = [[self bannerView] frame];
    bannerFrame.origin.y += offset;
    
    CGRect tableFrame = [[self mapView] frame];
    tableFrame.size.height += offset;
    
    [UIView beginAnimations:@"MoveAdOffScreen" context:nil];
    [[self bannerView] setFrame:bannerFrame];
    [[self mapView] setFrame:tableFrame];
    [UIView commitAnimations];
    
    bannerVisible = NO;
}

- (void)moveBannerOnScreen {
    if (bannerVisible) return;
    
    float offset = self.bannerView.frame.size.height;
    
    CGRect bannerFrame = [[self bannerView] frame];
    bannerFrame.origin.y -= offset;
    
    CGRect tableFrame = [[self mapView] frame];
    tableFrame.size.height -= offset;
    
    [UIView beginAnimations:@"MoveAdOnScreen" context:nil];
    [[self bannerView] setFrame:bannerFrame];
    [[self mapView] setFrame:tableFrame];
    [UIView commitAnimations];
    
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
