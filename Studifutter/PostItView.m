//
//  PostItView.m
//  Studifutter
//
//  Created by Florian Heiber on 21.12.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "PostItView.h"

@implementation PostItView

@synthesize postItText = _postItText;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *postItImage = [UIImage imageNamed:@"studifutter-post-it.png"];
        
        _postItImageView = [[UIImageView alloc] initWithFrame:frame];
        [_postItImageView setImage:postItImage];
        [self addSubview:_postItImageView];
        
        _textField = [[UITextField alloc] initWithFrame:frame];
        [_textField setBackgroundColor:[UIColor clearColor]];
        [_textField setFont:[UIFont fontWithName:@"Marker Felt" size:14]];
        [_postItImageView addSubview:_textField];
    }
    return self;
}

- (void)setPostItText:(NSString *)postItText {
    _postItText = postItText;
    [_textField setText:_postItText];
}

@end
