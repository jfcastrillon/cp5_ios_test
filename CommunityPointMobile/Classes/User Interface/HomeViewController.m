//
//  HomeViewController.m
//  CommunityPointMobile
//
//  Created by Matthew Baker on 9/29/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "HomeViewController.h"
#import "SettingsHelper.h"
#import "CommonSearchesViewController.h"

@implementation HomeViewController

@synthesize tableView, website, helpVideo, fullResourceList;
@synthesize aboutViewController;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	// Get singleton instance of the helper
	xsHelper = [XServicesHelper sharedInstance];
	[self.navigationController setNavigationBarHidden:YES animated:NO];

    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.tableView = nil;
	self.aboutViewController = nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
	[tableView reloadData];
	tableView.backgroundColor = [UIColor clearColor];
	[self.navigationController setNavigationBarHidden:YES animated:YES];

	[super viewWillAppear:animated];
}

- (void)dealloc {
	[tableView release];
	[website release];
	[helpVideo release];
    [fullResourceList release];
	[aboutViewController release];
	
    [super dealloc];
}

- (IBAction) videoButtonPressed: (id) sender {
	NSString *url = [[[SettingsHelper sharedInstance] settings] objectForKey:@"helpVideo"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
}

- (IBAction) websiteButtonPressed: (id) sender {
	NSString *url = [[[SettingsHelper sharedInstance] settings] objectForKey:@"website"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
}

- (IBAction) fullResourceListButtonPressed:(id)sender {
    if([[LocationManager sharedInstance] isLocationEnabled]) {
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didGetLocation:) name:LocationManagerFoundLocationNotification object: [LocationManager sharedInstance]];
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didFailToGetLocation:) name:LocationManagerFindLocationFailedNotification object: [LocationManager sharedInstance]];
        [[LocationManager sharedInstance] startFindingCurrentLocation];
    } else {
        [[XServicesHelper sharedInstance] searchResourcesWithQuery:@""];
        [[self.tabBarController.viewControllers objectAtIndex:1] popToRootViewControllerAnimated:NO];
        [self.tabBarController setSelectedIndex:1];
    }
}

// Callbacks for loaction notifications
- (void) didGetLocation: (NSNotification*) notification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:LocationManagerFindLocationFailedNotification object:[LocationManager sharedInstance]];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:LocationManagerFoundLocationNotification object: [LocationManager sharedInstance]];
	CLLocation* location = [[notification userInfo] objectForKey:kLocationManagerCurrentLocation];
	[[XServicesHelper sharedInstance] searchResourcesWithQuery:@"" forLatitude: [NSNumber numberWithDouble:location.coordinate.latitude] andLongitude: [NSNumber numberWithDouble:location.coordinate.longitude]];
    [[self.tabBarController.viewControllers objectAtIndex:1] popToRootViewControllerAnimated:NO];
	[self.tabBarController setSelectedIndex:1];
}

- (void) didFailToGetLocation: (NSNotification*) notification {
	// Stop listening for 
	[[NSNotificationCenter defaultCenter] removeObserver:self name:LocationManagerFindLocationFailedNotification object:[LocationManager sharedInstance]];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:LocationManagerFoundLocationNotification object:[LocationManager sharedInstance]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Error" message:@"Could not determine your location.  Using relevancy ranking instead." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[xsHelper searchResourcesWithQuery: @""];
    [[self.tabBarController.viewControllers objectAtIndex:1] popToRootViewControllerAnimated:NO];
	[self.tabBarController setSelectedIndex:1];
}


- (void) showAboutView {
	aboutViewController.delegate = self;
	aboutViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.parentViewController.parentViewController presentModalViewController: aboutViewController animated:YES];
}

- (void) aboutViewShouldDismiss {
	[self dismissModalViewControllerAnimated: YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell*)tableView:(UITableView*)_tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	static NSString *CellIdentifier = @"Identifier";
	
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}

	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = @"Common Searches";
	
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CommonSearchesViewController *commonViewController = [[CommonSearchesViewController alloc] initWithNibName:@"CommonSearchesViewController" bundle:[NSBundle mainBundle]];
	[commonViewController setLoading:YES];
	[self.navigationController pushViewController:commonViewController animated:YES];
	
	[commonViewController release];
	
	[xsHelper cancelAllOperations];
	[xsHelper loadCommonSearches];
}

@end
