//
//  SFInfoViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFInfoViewController.h"
#import "TestFlight.h"
#import "SFWebViewController.h"

@implementation SFInfoViewController

@synthesize delegate = _delegate;
@synthesize versionLabel = _versionLabel;

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowWebView"]) {
        SFWebViewController *webViewController = (SFWebViewController *)[segue destinationViewController];
        [webViewController setWebURL:[NSURL URLWithString:@"http://www.twitter.com/studifutter"]];
        [webViewController setTitle:@"Twitter"];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [TestFlight passCheckpoint:INFO_SHOW_CHECKPOINT];
    
    [[self versionLabel] setText:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

- (void)viewDidUnload
{
    [self setVersionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.delegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)done:(id)sender {
    [[self delegate] dismissInfoView];
}

- (IBAction)feedback:(id)sender {
    [TestFlight openFeedbackView];
}

- (IBAction)mail:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        [mailComposer setSubject:NSLocalizedString(@"MAIL_SUBJECT_FEEDBACK", @"Subject line")];
        [mailComposer setToRecipients:[NSArray arrayWithObject:@"studifutter@rtfnt.com"]];
        [mailComposer setMailComposeDelegate:self];
        [[mailComposer navigationBar] setBarStyle:UIBarStyleBlack];
        [self presentModalViewController:mailComposer animated:YES];
    } else {
        NSString *mailURLString = [NSString stringWithFormat:@"mailto:studifutter@rtfnt.com?subject=%@", NSLocalizedString(@"MAIL_SUBJECT_FEEDBACK", @"Subject line")];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailURLString]];
    }
}

#pragma mark - MFMailComposeDelegate 

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

@end
