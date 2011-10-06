//
//  MealTableViewCell.m
//  Mensa
//
//  Created by Florian Heiber on 01.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "MealTableViewCell.h"

@implementation MealTableViewCell

@synthesize dateLabel, textLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		
		// we need a view to place our labels on.
		UIView *myContentView = self.contentView;
		
		/*
		 init the title label.
		 set the text alignment to align on the left
		 add the label to the subview
		 release the memory
		 */
		self.dateLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:14.0 bold:YES];
		self.dateLabel.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview:self.dateLabel];
		[self.dateLabel release];
		
		/*
		 init the url label. (you will see a difference in the font color and size here!
		 set the text alignment to align on the left
		 add the label to the subview
		 release the memory
		 */
        self.textLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor lightGrayColor] fontSize:10.0 bold:NO];
		[myContentView addSubview:self.textLabel];
		[self.textLabel release];
	}
	
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	// Configure the view for the selected state
}

/*
 this function gets in data from another area in the code
 you can see it takes a NSDictionary object
 it then will set the label text
 */
-(void)setData:(NSDictionary *)dict {
	NSDate *date = [dict objectForKey:@"date"];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	NSDateFormatter *dayFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dayFormatter setDateFormat:@"EEEE"]; // http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
	
	NSString *weekday = [dayFormatter stringFromDate:date];
	NSString *labelText;
	labelText = [weekday stringByAppendingString:@", "];
	labelText = [labelText stringByAppendingString:[dateFormatter stringFromDate:date]];
	UIFont *dateFont = [UIFont boldSystemFontOfSize:16];
	UIFont *textFont = [UIFont systemFontOfSize:12];
	
	self.dateLabel.text = labelText;
	self.dateLabel.font = dateFont;
	self.textLabel.text = [dict objectForKey:@"text"];
	self.textLabel.font = textFont;
	self.textLabel.text = [self.textLabel.text stringByReplacingOccurrencesOfString:@"\n" withString: @""];
}

/*
 this function will layout the subviews for the cell
 if the cell is not in editing mode we want to position them
 */
- (void)layoutSubviews {
	
    [super layoutSubviews];
	
	// getting the cell size
    CGRect contentRect = self.contentView.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
    if (!self.editing) {
		
		// get the X pixel spot
        CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
		
        /*
		 Place the title label.
		 place the label whatever the current X is plus 10 pixels from the left
		 place the label 4 pixels from the top
		 make the label 200 pixels wide
		 make the label 20 pixels high
		 */
		frame = CGRectMake(boundsX + 10, 4, 275, 20);
		self.dateLabel.frame = frame;
		
		// place the url label
		frame = CGRectMake(boundsX + 10, 28, 275, 14);
		self.textLabel.frame = frame;
	}
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
	/*
	 Create and configure a label.
	 */
	
    UIFont *font;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        font = [UIFont systemFontOfSize:fontSize];
    }
	
    /*
	 Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults.  To show selection properly, however, the views need to be transparent (so that the selection color shows through).  This is handled in setSelected:animated:.
	 */
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}

- (void)dealloc {
	[textLabel release];
	[dateLabel release];
    [super dealloc];
}

@end
