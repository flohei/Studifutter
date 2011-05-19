//
//  MensaListViewController.m
//  Mensa
//
//  Created by Florian Heiber on 02.04.09.
//  Copyright 2009 rootof.net Florian Heiber & Daniel Wiewel GbR. All rights reserved.
//

#import "MensaListViewController.h"
#import "Mensa.h"

@implementation MensaListViewController
@synthesize mensaArray;

- (void)viewDidLoad {
	[super viewDidLoad];

	self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
	
	mensaArray = [self createMensaArray];
	self.navigationItem.title = @"Wo futtern?";
}

#pragma mark -
#pragma mark custom methods

- (NSArray *)createMensaArray {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	Mensa *m1 = [[Mensa alloc] init];
	m1.name = @"Mensa Langemarckplatz Erlangen";
	m1.street = @"Langemarckplatz 4";
	m1.zipcode = @"91054";
	m1.city = @"Erlangen";
	m1.latitude = 100;
	m1.longitude = 100;
	m1.googleMapsURL = [NSURL URLWithString:@"http://maps.google.de/maps?f=q&hl=de&geocode=&q=Langemarckplatz+4,+91054+Erlangen&sll=49.454707,11.094432&sspn=0.011996,0.028024&ie=UTF8&ll=49.594773,11.009846&spn=0.011961,0.028024&z=15&iwloc=addrn"];
	[array addObject:m1];
	[m1 release];
	
	Mensa *m2 = [[Mensa alloc] init];
	m2.name = @"Südmensa Erlangen";
	m2.street = @"Erwin-Rommel-Str. 60";
	m2.zipcode = @"91058";
	m2.city = @"Erlangen";
	m2.latitude = 100;
	m2.longitude = 100;
	m2.googleMapsURL = [NSURL URLWithString:@"http://maps.google.de/maps?f=q&hl=de&geocode=&q=Erwin-Rommel-Str.+60,+91058+Erlangen&sll=49.594773,11.009846&sspn=0.011961,0.028024&ie=UTF8&ll=49.576995,11.029758&spn=0.011966,0.028024&z=15&iwloc=addr"];
	[array addObject:m2];
	[m2 release];
	
	Mensa *m3 = [[Mensa alloc] init];
	m3.name = @"Mensa Insel Schütt Nürnberg";
	m3.street = @"Andreij-Sacharow-Platz 1";
	m3.zipcode = @"90403";
	m3.city = @"Nürnberg";
	m3.latitude = 100;
	m3.longitude = 100;
	m3.googleMapsURL = [NSURL URLWithString:@"http://maps.google.de/maps?f=q&hl=de&geocode=&q=Andreij-Sacharow-Platz+1,+90403+N%C3%BCrnberg&sll=49.576995,11.029758&sspn=0.011966,0.028024&ie=UTF8&ll=49.455544,11.084003&spn=0.011996,0.028024&z=15&iwloc=addr"];
	[array addObject:m3];
	[m3 release];
	
	Mensa *m4 = [[Mensa alloc] init];
	m4.name = @"Mensa Regensburger Straße Nürnberg";
	m4.street = @"Regensburger Str. 160";
	m4.zipcode = @"90478";
	m4.city = @"Nürnberg";
	m4.latitude = 100;
	m4.longitude = 100;
	m4.googleMapsURL = [NSURL URLWithString:@"http://maps.google.de/maps?f=q&hl=de&geocode=&q=Regensburger+Str.+160,+90478+N%C3%BCrnberg&sll=49.455544,11.084003&sspn=0.011996,0.028024&ie=UTF8&ll=49.440562,11.112843&spn=0.011999,0.028024&z=15&iwloc=addr"];
	[array addObject:m4];
	[m4 release];
	
	Mensa *m5 = [[Mensa alloc] init];
	m5.name = @"Mensateria";
	m5.street = @"Wollentorstr. 4";
	m5.zipcode = @"90409";
	m5.city = @"Nürnberg";
	m5.latitude = 100;
	m5.longitude = 100;
	m5.googleMapsURL = [NSURL URLWithString:@"http://maps.google.de/maps?f=q&hl=de&geocode=&q=Wollentorstr.+4,+90409+N%C3%BCrnberg&sll=51.151786,10.415039&sspn=11.864215,28.696289&ie=UTF8&ll=49.454707,11.094432&spn=0.011996,0.028024&z=15&iwloc=cent"];
	[array addObject:m5];
	[m5 release];
	
	Mensa *m6 = [[Mensa alloc] init];
	m6.name = @"Eichstätt";
	m6.street = @"Universitätsallee 2";
	m6.zipcode = @"85072";
	m6.city = @"Eichstätt";
	m6.latitude = 100;
	m6.longitude = 100;
	m6.googleMapsURL = [NSURL URLWithString:@"http://maps.google.de/maps?f=q&hl=de&geocode=&q=Universit%C3%A4tsallee+2,+85072+Eichst%C3%A4tt&sll=49.440562,11.112843&sspn=0.011999,0.028024&ie=UTF8&ll=48.888649,11.190262&spn=0.012134,0.028024&z=15&iwloc=addr"];
	[array addObject:m6];
	[m6 release];
	
	Mensa *m7 = [[Mensa alloc] init];
	m7.name = @"Ingolstadt";
	m7.street = @"Esplanade 10";
	m7.zipcode = @"85049";
	m7.city = @"Ingolstadt";
	m7.latitude = 100;
	m7.longitude = 100;
	m7.googleMapsURL = [NSURL URLWithString:@"http://maps.google.de/maps?f=q&hl=de&geocode=&q=Esplanade+10,+85049+Ingolstadt&sll=48.888649,11.190262&sspn=0.012134,0.028024&ie=UTF8&ll=48.768438,11.43136&spn=0.012163,0.028024&z=15&iwloc=addr"];
	[array addObject:m7];
	[m7 release];
	
	Mensa *m8 = [[Mensa alloc] init];
	m8.name = @"Ansbach";
	m8.street = @"Residenzstr. 8";
	m8.zipcode = @"91522";
	m8.city = @"Ansbach";
	m8.latitude = 100;
	m8.longitude = 100;
	m8.googleMapsURL = [NSURL URLWithString:@"http://maps.google.de/maps?f=q&hl=de&geocode=&q=Residenzstra%C3%9Fe+8,+91522+Ansbach&sll=48.768438,11.43136&sspn=0.012163,0.028024&ie=UTF8&ll=49.306322,10.569792&spn=0.012032,0.028024&z=15&iwloc=addr"];
	[array addObject:m8];
	[m8 release];
	
	return array;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mensaArray.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell = [[[UITableViewCell alloc] init] autorelease];
    }
    
    // Set up the cell...
	Mensa *m = [mensaArray objectAtIndex:indexPath.row];
	cell.text = m.name;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// move to google maps here
	Mensa *m = [mensaArray objectAtIndex:indexPath.row];
	[[UIApplication sharedApplication] openURL:m.googleMapsURL];
	[m release];
}

- (void)dealloc {
	[mensaArray release];
    [super dealloc];
}

@end
