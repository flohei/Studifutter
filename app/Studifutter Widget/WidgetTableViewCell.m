//
//  WidgetTableViewCell.m
//  Studifutter
//
//  Created by Florian Heiber on 04/10/14.
//  Copyright (c) 2014 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "WidgetTableViewCell.h"
#import "Menu.h"

@implementation WidgetTableViewCell

@synthesize menu = _menu;

- (void)awakeFromNib {
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setMenu:(Menu *)menu {
    _menu = menu;
    
    [[self menuTitleLabel] setText:[_menu name]];
    
    NSLocale *german = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:german];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSString *priceString1 = [formatter stringFromNumber:[_menu price]];
    NSString *priceString2 = [formatter stringFromNumber:[_menu reducedPrice]];
    
    NSMutableString *infoString = [NSMutableString stringWithFormat:@"%@/%@", priceString1, priceString2];
    
    [[self menuPriceLabel] setText:infoString];
}

- (Menu *)menu {
    return _menu;
}

@end
