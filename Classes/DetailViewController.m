//
//  DetailViewController.m
//  Mensa
//
//  Created by Florian Heiber on 02.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "DetailViewController.h"
#import "MealSet.h"
#import "RestaurantAppDelegate.h"
#import "MultilineTableViewCell.h"

#define kTableViewRowHeight 66

@implementation DetailViewController
@synthesize currentMeal;

- (void)viewDidLoad {
    [super viewDidLoad];

	NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	
	// add the label with the information
	NSString *text = @"Beilagen sind nicht im Preis enthalten, X = kein Schweinefleisch, V = Vegetarisch, R = Rindfleisch, 1 mit Farbstoff, 4 mit Konservierungsstoff, 7 mit Antioxidationsmittel, 8 mit Geschmacksverstärker, 9 geschwefelt, 10 geschwärzt, 11 gewachst, 12 mit Phosphat, 5 mit Süßungsmittel, Änderungen vorbehalten.";
	UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 265, 300, 80)];
	UIFont *font = [UIFont systemFontOfSize:10];
	infoLabel.text = text;
	infoLabel.font = font;
	infoLabel.lineBreakMode = UILineBreakModeWordWrap;
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.numberOfLines = 10;
	
	[[self view] addSubview:infoLabel];
	
	self.navigationItem.title = [formatter stringFromDate:currentMeal.date];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [currentMeal.meals count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    MultilineTableViewCell *cell = (MultilineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[MultilineTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
	cell.text = [(Meal *)[currentMeal.meals objectAtIndex:indexPath.row] title];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kTableViewRowHeight;
}

- (void)dealloc {
	[currentMeal release];
    [super dealloc];
}

@end
