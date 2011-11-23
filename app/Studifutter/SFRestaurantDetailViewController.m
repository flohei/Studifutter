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
#import "Constants.h"

@interface SFRestaurantDetailViewController ()

- (void)moveBannerOffScreen;
- (void)moveBannerOnScreen;

@end

@implementation SFRestaurantDetailViewController
@synthesize streetLabel = _streetLabel;
@synthesize zipAndCityLabel = _zipAndCityLabel;
@synthesize notesLabel = _notesLabel;
@synthesize mapView = _mapView;
@synthesize bannerView = _bannerView;
@synthesize restaurant = _restaurant;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self moveBannerOnScreen];
    
    self.navigationItem.title = _restaurant.name;
    self.streetLabel.text = _restaurant.street;
    self.zipAndCityLabel.text = [NSString stringWithFormat:@"%@ %@", _restaurant.zipCode, _restaurant.city];
    self.notesLabel.text = _restaurant.notes;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;
    
    CLLocationCoordinate2D restaurantLocation;
    restaurantLocation.longitude = [_restaurant.longitude doubleValue];
    restaurantLocation.latitude = [_restaurant.latitude doubleValue];
    
    region.span = span;
    region.center = restaurantLocation;
    
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
	return annotationView;
}

#pragma mark - iAds

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
