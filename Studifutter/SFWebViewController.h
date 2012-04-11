//
//  SFWebViewController.h
//  Studifutter
//
//  Created by Florian Heiber on 11.04.12.
//  Copyright (c) 2012 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic) NSURL *webURL;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
