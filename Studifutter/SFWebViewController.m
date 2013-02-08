//
//  SFWebViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 11.04.12.
//  Copyright (c) 2012 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFWebViewController.h"

@interface SFWebViewController ()

@end

@implementation SFWebViewController

@synthesize webView = _webView;
@synthesize webURL = _webURL;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if ([self webURL]) {
        [[self webView] loadRequest:[NSURLRequest requestWithURL:_webURL]];
    }
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setWebURL:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
