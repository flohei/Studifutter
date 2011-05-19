//
//  MultilineTableViewCell.m
//  Mensa
//
//  Created by Florian Heiber on 03.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "MultilineTableViewCell.h"

@implementation MultilineTableViewCell
@synthesize label;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// The frame variable is not used in this method. If you want to use it,
		// you should set it to CGRectMake(10, 10, 280, 60)
		
		self.contentView.frame = CGRectMake(10, 10, 280, 60);
		
        UIFont *font = [UIFont systemFontOfSize:17];
		label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.contentView.frame.size.width - 20, self.contentView.frame.size.height - 20)] autorelease];
		label.font = font;
		label.lineBreakMode = UILineBreakModeWordWrap;
		label.numberOfLines = 2;
		label.contentMode = UIViewContentModeScaleAspectFill;
		
		[[self contentView] addSubview:label];
		
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (CGFloat)heightForTableViewWidth:(CGFloat)width {
	return [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(width - 40.0, 1000) lineBreakMode:label.lineBreakMode].height + 20.0;
}

- (void)setText:(NSString *)text {
	if (text.length > 60) {
		UIFont *font = [UIFont systemFontOfSize:16];
		label.font = font;
		[font release];
	}
	
	label.text = text;
}

- (NSString *)text {
	return label.text;
}

- (void)dealloc {
	[super dealloc];
}

@end
