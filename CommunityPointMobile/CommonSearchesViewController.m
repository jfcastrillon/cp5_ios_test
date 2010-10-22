//
//  CommonSearchesViewController.m
//  CommunityPointMobile
//
//  Created by Matthew Baker on 10/22/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CommonSearchesViewController.h"
#import "XServicesHelper.h"

@implementation CommonSearchesViewController
@synthesize commonSearches;

- (void) didReceiveCommonSearches: (NSNotification*) notification {
	self.commonSearches = [xsHelper commonSearches];
	
	[self.tableView reloadData];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void) commonSearchesRequestFailed: (NSNotification*) notification {
	UIAlertView *alert;
	if(![[NetworkManager sharedInstance] isInternetConnectionAvailable]) {
		alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet connection available.  A data connection is required to use this app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		//Trigger app lockdown?
	} else {
		alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to retrieve common searches.  It appears the service is down." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	}
	
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.title = @"Common Searches";
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	// Get singleton instance of the helper
	xsHelper = [XServicesHelper sharedInstance];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didReceiveCommonSearches:) name:@"CommonSearchesReceived" object: xsHelper];
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(commonSearchesRequestFailed:) name:@"CommonSearchesRequestFailed" object: xsHelper];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"CommonSearchesReceived" object:xsHelper];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"CommonSearchesRequestFailed" object:xsHelper];

    [super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (commonSearches == nil) {
		return 0;
	} else {
		return [commonSearches count];		
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	CPMCommonSearch* cs = [commonSearches objectAtIndex:row];
	cell.textLabel.text = [cs name];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[[NSNotificationCenter defaultCenter] removeObserver: self];

	[super viewDidUnload];
}


- (void)dealloc {
	[commonSearches release];
    [super dealloc];
}


@end

