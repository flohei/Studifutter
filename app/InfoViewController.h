//
//  InfoViewController.h
//  Mensa
//
//  Created by Florian Heiber on 08.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoViewController : UIViewController {
	IBOutlet UILabel *versionLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *versionLabel;

- (IBAction)sendMail:(id)sender;

@end
