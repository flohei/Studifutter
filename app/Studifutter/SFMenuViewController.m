//
//  SFMenuViewController.m
//  Studifutter
//
//  Created by Florian Heiber on 31.10.11.
//  Copyright (c) 2011 rootof.net Heiber & Wiewel GbR. All rights reserved.
//

#import "SFMenuViewController.h"
#import "SFDayListViewController.h"
#import "Restaurant.h"
#import "MenuSet.h"
#import "Menu.h"
#import "MenuTableViewCell.h"
#import <Social/Social.h>
#import "SFActivityProvider.h"

@interface SFMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *footerView;
- (NSArray *)allMenus;
- (NSArray *)allMenuSets;

- (void)setupInterface;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;

@end

@implementation SFMenuViewController

@synthesize menuSet = _menuSet;
@synthesize swipeGestureRecognizer = _swipeGestureRecognizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSwipeGestureRecognizer:[[UISwipeGestureRecognizer alloc] init]];
    [[self swipeGestureRecognizer] addTarget:self action:@selector(handleSwipeLeftGesture:)];
    [[self swipeGestureRecognizer] setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:[self swipeGestureRecognizer]];
    [self setSwipeGestureRecognizer:nil];
    
    [self setSwipeGestureRecognizer:[[UISwipeGestureRecognizer alloc] init]];
    [[self swipeGestureRecognizer] addTarget:self action:@selector(handleSwipeRightGesture:)];
    [[self swipeGestureRecognizer] setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:[self swipeGestureRecognizer]];
    [self setSwipeGestureRecognizer:nil];
    
    [self setupInterface];
}

- (void)viewDidUnload {
    [self setSwipeGestureRecognizer:nil];
    [super viewDidUnload];
}

- (void)setupInterface {
    NSString *restaurantNotes = [[[self menuSet] restaurant] notes];
    if (![restaurantNotes isEqualToString:[NSString string]]) {        
        // get the font
        UIFont *theFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        
        // create and configure the final label
        [[self notesLabel] setFont:theFont];
        [[self notesLabel] setText:restaurantNotes];
        [[self notesLabel] setBackgroundColor:[UIColor clearColor]];
        [[self notesLabel] setNumberOfLines:0];
        [[self notesLabel] setLineBreakMode:NSLineBreakByWordWrapping];
        [[self notesLabel] setPreferredMaxLayoutWidth:200];
        [[self notesLabel] setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [[self notesLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [[self footerView] setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    
    NSDateFormatter *titleDateFormatter = [[NSDateFormatter alloc] init];
    [titleDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [titleDateFormatter setDoesRelativeDateFormatting:YES];
    
    NSString *dateString = [titleDateFormatter stringFromDate:[[self menuSet] date]];
    [[self navigationItem] setTitle:dateString];
}

- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)recognizer {
    NSArray *allMenus = [self allMenuSets];
    MenuSet *nextMenuSet = nil;
    BOOL currentMenuSetFound = NO;
    
    for (MenuSet *ms in allMenus) {
        if (currentMenuSetFound) {
            nextMenuSet = ms;
            break;
        }
        
        if ([ms isEqual:[self menuSet]]) currentMenuSetFound = YES;
    }
    
    if (nextMenuSet) {
        [self setMenuSet:nextMenuSet];
        [[self tableView] reloadData];
        [self setupInterface];
    }
}

- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer *)recognizer {
    NSArray *allMenus = [self allMenuSets];
    MenuSet *previousMenuSet = nil;
    BOOL currentMenuSetFound = NO;
    
    for (MenuSet *ms in allMenus) {
        if ([ms isEqual:[self menuSet]]) {
            currentMenuSetFound = YES;
            break;
        }
        
        previousMenuSet = ms;
    }
    
    if (currentMenuSetFound && previousMenuSet) {
        [self setMenuSet:previousMenuSet];
        [[self tableView] reloadData];
        [self setupInterface];
    }
}

- (IBAction)showActionMenu:(id)sender {
    SFActivityProvider *activityProvider = [[SFActivityProvider alloc] initWithPlaceholderItem:@"Default"];
    [activityProvider setMenuSet:[self menuSet]];
    NSArray *activityItems = @[activityProvider];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (NSArray *)allMenuSets {
    NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSSet *unsortedMenuSet = [[[self menuSet] restaurant] menuSet];
    return [unsortedMenuSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSortDescriptor]];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Misc

- (NSArray *)allMenus {
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return [[[self menuSet] menu] sortedArrayUsingDescriptors:sortDescriptors];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self allMenus] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCellIdentifier";
    
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Menu *menu = [[self allMenus] objectAtIndex:[indexPath row]];
    
    // Configure the cell...
    [cell setMenu:menu];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Menu *menu = [[self allMenus] objectAtIndex:[indexPath row]];
    
    CGSize maximumSize = CGSizeMake(260, 500);
    CGRect labelRect = [[menu name] boundingRectWithSize:maximumSize
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}
                                                 context:nil];
    
    CGSize titleSize = labelRect.size;
    
    return titleSize.height + 40.0;
}

@end
