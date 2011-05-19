//
//  InfoViewController.m
//  Mensa
//
//  Created by Florian Heiber on 08.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController
@synthesize versionLabel;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	versionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	self.navigationItem.title = @"Info";
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (IBAction)sendMail:(id)sender
{
	NSString *mailURL = @"mailto:?to=studifutter@rootof.net&subject=Studifutter App";
	mailURL = [mailURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailURL]];
	[mailURL release];
}

- (void)dealloc {
	[versionLabel release];
    [super dealloc];
}


@end
