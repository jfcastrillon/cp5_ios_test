//
//  SearchViewController.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SearchViewController.h"
#import "CPMResource.h"
#import "CPMResourceDetail.h"
#import "CPMSearchResultSet.h"

#import "XServicesHelper.h"
#import "ResourceDetailViewController.h"
#import "NetworkManager.h"


@implementation SearchViewController
@synthesize resultsTableView;
@synthesize searchBar;
@synthesize busyIndicator;
@synthesize dimmingOverlay;
@synthesize searchResults;
@synthesize xsHelper;
@synthesize loadMoreCell;

- (void) showOverlay {
	CATransition *animation = [CATransition animation];
	[animation setType: kCATransitionFade];
	[animation setDuration: 0.3];
	[animation setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[dimmingOverlay layer] addAnimation:animation forKey:@"overlayTransition"];
	dimmingOverlay.hidden = NO;
	dimmingOverlay.alpha  = 0.7f;
}

- (void) hideOverlay {
	CATransition *animation = [CATransition animation];
	[animation setType: kCATransitionFade];
	[animation setDuration: 0.3];
	[animation setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[dimmingOverlay layer] addAnimation:animation forKey:@"overlayTransition"];
	dimmingOverlay.hidden = YES;
	dimmingOverlay.alpha  = 0.0f;
}

- (IBAction) backgroundTap:(id)sender {
	if([searchBar isFirstResponder]) {
		[searchBar setShowsCancelButton:NO animated:YES];
		[searchBar setShowsScopeBar:NO];
		[searchBar sizeToFit];
		resultsTableView.allowsSelection = YES;
		resultsTableView.scrollEnabled = YES;
		[searchBar resignFirstResponder];
		if([busyIndicator isHidden]) // Don't hide the overlay when a search is in progress
			[self hideOverlay];
	}
}


- (void)viewDidLoad {
	// Get singleton instance of the helper
	xsHelper = [XServicesHelper sharedInstance];
	self.searchResults = [xsHelper searchResults];
	locationManager = [LocationManager sharedInstance];
	
	// Observe the notifications for completed search results
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didReceiveSearchResults:) name:@"SearchResultsReceived" object: xsHelper];
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didReceiveMoreSearchResults:) name:@"SearchResultsAppended" object: xsHelper];
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(searchRequestFailed:) name:@"SearchRequestFailed" object: xsHelper];
		
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	self.searchBar = nil;
	self.resultsTableView = nil;
	self.busyIndicator = nil;
	self.dimmingOverlay = nil;
	self.loadMoreCell = nil;
}

- (void)dealloc {
	[searchResults release];
	[resultsTableView release];
	[searchBar release];
	[busyIndicator release];
	[dimmingOverlay release];
	[xsHelper release];
	[loadMoreCell release];
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
	[searchBar setShowsScopeBar:NO];
	[searchBar sizeToFit];
	[resultsTableView reloadData];
    [super viewWillAppear:animated];
}


- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}


- (void) didReceiveSearchResults: (NSNotification*) notification {
	self.searchResults = [xsHelper searchResults];
	[resultsTableView setHidden: NO];
	[busyIndicator setHidden:YES];
	[self hideOverlay];
	[resultsTableView reloadData];
	[resultsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void) didReceiveMoreSearchResults: (NSNotification*) notification {
	self.searchResults = [xsHelper searchResults];
	isLoadingMore = NO;
	[loadMoreCell.activityIndicator setHidden:YES];
	[resultsTableView reloadData];
}

- (void) searchRequestFailed: (NSNotification*) notification {
	UIAlertView *alert;
	if(![[NetworkManager sharedInstance] isInternetConnectionAvailable]) {
		alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet connection available.  A data connection is required to use this app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		//Trigger app lockdown?
	} else {
		alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to retrieve search results.  It appears the service is down." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	}

	[alert show];
	[alert release];
	
	[busyIndicator setHidden: YES];
	[self hideOverlay];
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	if(searchResults == nil)
		return 0;
	else 
		return [searchResults count] + 1;		
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	static NSString *ResourceSearchResultCellIdentifier = @"ResourceSearchResultCell";
	
	NSUInteger row = [indexPath row];
	ResourceSearchResultCell *cell = (ResourceSearchResultCell*) [tableView dequeueReusableCellWithIdentifier:ResourceSearchResultCellIdentifier];

	if(cell == nil){
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ResourceSearchResultCell" owner:self options:nil];
		for (id oneObject in nib) if ([oneObject isKindOfClass:[ResourceSearchResultCell class]])
			cell = (ResourceSearchResultCell *)oneObject;
	}

	if (isLoadingMore == YES && row == [searchResults count]) {
		cell.activityIndicator.hidden = NO;
		[cell.activityIndicator startAnimating];
	} else {
		cell.activityIndicator.hidden = YES;
	}

	if (row == [searchResults count]) {
		int remaining = [[[xsHelper lastSearchResultSet] totalCount] intValue] - [[[xsHelper lastSearchResultSet] count] intValue];
		cell.nameLabel.text = @"Load More Results";
		cell.addressLabel.text = [NSString stringWithFormat:@"%d Results Remaining", remaining];
		cell.nameLabel.textColor = [UIColor colorWithRed:0.0 green:0.25098 blue:0.501961 alpha:1.0];
		cell.distanceLabel.text = @"";
		[cell.handicapImage setHidden:YES];
		[cell.bedImage setHidden:YES];
		loadMoreCell = cell;
		[loadMoreCell retain];
	} else {
		CPMResource* resource = [searchResults objectAtIndex:row];
		cell.nameLabel.text = [resource name];
		if ([resource distanceToRef] != nil) {
			if ([[resource distanceToRef] floatValue] >= 10.0f) {
				cell.distanceLabel.text = [NSString stringWithFormat:@"%d miles", [[resource distanceToRef] intValue]];
			} else {
				cell.distanceLabel.text = [NSString stringWithFormat:@"%.2f miles", [[resource distanceToRef] floatValue]];
			}
		} else {
			cell.distanceLabel.text = @"";
		}
		
		if ([resource shelterFlag] != nil && [[resource shelterFlag] boolValue]) {
			[cell.bedImage setHidden:NO];
		} else {
			[cell.bedImage setHidden:YES];
		}
		
		if ([resource accessibilityFlag] != nil && [[resource accessibilityFlag] boolValue]) {
			[cell.handicapImage setHidden:NO];
		} else {
			[cell.handicapImage setHidden:YES];
		}

		cell.addressLabel.text = [resource addressString];
		cell.nameLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
	return kTableViewRowHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = [indexPath row];
	
	if (row == [[xsHelper searchResults] count]) {
		[loadMoreCell.activityIndicator setHidden:NO];
		[loadMoreCell.activityIndicator startAnimating];
		isLoadingMore = YES;
		[xsHelper loadMoreResults];
	} else {
		CPMResource *resource = [[xsHelper searchResults] objectAtIndex:row];
		
		// Change to other view before loading this?
		ResourceDetailViewController *detailViewController = [[ResourceDetailViewController alloc] initWithNibName:@"ResourceDetailViewController" bundle:[NSBundle mainBundle]];
		
		[self.navigationController pushViewController:detailViewController animated:YES];
		
		[detailViewController release];
		
		[xsHelper cancelAllOperations];
		[xsHelper loadResourceDetails: [resource resourceId]];
	}
}

- (void) beginSearchForQuery: (NSString*) query {
	[self showOverlay];
	[busyIndicator setHidden:NO];
	[busyIndicator startAnimating];
	if ([searchBar selectedScopeButtonIndex] == 0)
		[xsHelper searchResourcesWithQuery: query];
	else {
		[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didGetLocation:) name:LocationManagerFoundLocationNotification object: locationManager];
		[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didFailToGetLocation:) name:LocationManagerFindLocationFailedNotification object: locationManager];
		[locationManager startFindingCurrentLocation];
	}
}

// Callbacks for loaction notifications
- (void) didGetLocation: (NSNotification*) notification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:LocationManagerFindLocationFailedNotification object:locationManager];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:LocationManagerFoundLocationNotification object:locationManager];
	CLLocation* location = [[notification userInfo] objectForKey:kLocationManagerCurrentLocation];
	[xsHelper searchResourcesWithQuery:[searchBar text] forLatitude: [NSNumber numberWithDouble:location.coordinate.latitude] andLongitude: [NSNumber numberWithDouble:location.coordinate.longitude]];
}

- (void) didFailToGetLocation: (NSNotification*) notification {
	// Stop listening for 
	[[NSNotificationCenter defaultCenter] removeObserver:self name:LocationManagerFindLocationFailedNotification object:locationManager];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:LocationManagerFoundLocationNotification object:locationManager];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Error" message:@"Could not determine your location.  Using relevancy ranking instead." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[xsHelper searchResourcesWithQuery: searchBar.text];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)sender {
	// Prevent a location search from being triggered if they start editing again
	[[NSNotificationCenter defaultCenter] removeObserver:self name:LocationManagerFindLocationFailedNotification object:locationManager];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:LocationManagerFoundLocationNotification object:locationManager];
	
	[sender setShowsCancelButton:YES animated:YES];
	if([locationManager isLocationEnabled])
		[sender setShowsScopeBar:YES];
	else {
		[sender setShowsScopeBar: NO];
		[sender setSelectedScopeButtonIndex: 0]; // Only allow relevancy if the location services are disabled
	}

	[searchBar sizeToFit];
	resultsTableView.allowsSelection = NO;
	resultsTableView.scrollEnabled = NO;
	[self showOverlay];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)sender {
	[sender setShowsCancelButton:NO animated:YES];
	[sender setShowsScopeBar:NO];
	[searchBar sizeToFit];
	resultsTableView.allowsSelection = YES;
	resultsTableView.scrollEnabled = YES;
	[sender resignFirstResponder];
	[self hideOverlay];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)sender {
	[self beginSearchForQuery: sender.text];
	[sender setShowsCancelButton:NO animated:YES];
	[sender setShowsScopeBar:NO];
	[searchBar sizeToFit];
	
	resultsTableView.allowsSelection = YES;
	resultsTableView.scrollEnabled = YES;
	[sender resignFirstResponder];
}

@end
