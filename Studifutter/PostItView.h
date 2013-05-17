//
//  PostItView.h
//  Studifutter
//
//  Created by Florian Heiber on 21.12.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostItView : UIView {
    UIImageView *_postItImageView;
    UITextField *_textField;
}

@property (nonatomic, retain) NSString *postItText;

@end
