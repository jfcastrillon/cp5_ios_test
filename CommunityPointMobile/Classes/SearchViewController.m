//
//  SearchViewController.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "SearchViewController.h"
#import "CPMResource.h"
#import "CPMResourceDetail.h"
#import "CPMSearchResultSet.h"

#import "XServicesHelper.h"
#import "ResourceSearchResultCell.h"
#import "ResourceDetailViewController.h"


@implementation SearchViewController
@synthesize resultsTableView;
@synthesize searchBar;
@synthesize busyIndicator;
@synthesize dimmingOverlay;
@synthesize searchResults;
@synthesize xsHelper;

- (IBAction) backgroundTap:(id)sender {
	[searchBar resignFirstResponder];
}


- (void)viewDidLoad {
	// Get singleton instance of the helper
	xsHelper = [XServicesHelper sharedInstance];
	
	// Observe the notifications for completed search results
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didReceiveSearchResults:) name:@"SearchResultsReceived" object: xsHelper];
		
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
	self.searchResults = nil;
	self.resultsTableView = nil;
	[operationQueue cancelAllOperations];
	[operationQueue release];
	operationQueue = nil;
}


- (void) showOverlay {
	[dimmingOverlay setHidden:NO];
}

- (void) hideOverlay {
	[dimmingOverlay setHidden:YES];
}

- (void)dealloc {
	[searchResults release];
	[searchBar release];
	[busyIndicator release];
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	if(searchResults == nil)
		return 0;
	else 
		return [searchResults count];		
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	static NSString *ResourceSearchResultCellIdentifier = @"ResourceSearchResultCell";
	
	ResourceSearchResultCell *cell = (ResourceSearchResultCell*) [tableView dequeueReusableCellWithIdentifier:ResourceSearchResultCellIdentifier];
	if(cell == nil){
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ResourceSearchResultCell" owner:self options:nil];
		for (id oneObject in nib) if ([oneObject isKindOfClass:[ResourceSearchResultCell class]])
			cell = (ResourceSearchResultCell *)oneObject;
	}
	
	NSUInteger row = [indexPath row];

	CPMResource* resource = [searchResults objectAtIndex:row];
	cell.nameLabel.text = [resource name];
	
	cell.addressLabel.text = [resource addressString];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
	return kTableViewRowHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = [indexPath row];
	CPMResource *resource = [[xsHelper searchResults] objectAtIndex:row];

	// Change to other view before loading this?
	ResourceDetailViewController *detailViewController = [[ResourceDetailViewController alloc] initWithNibName:@"ResourceDetailViewController" bundle:[NSBundle mainBundle]];
	
	[self.navigationController pushViewController:detailViewController animated:YES];
	
	[detailViewController release];
	
	[xsHelper loadResourceDetails: [resource resourceId]];
}

- (void) beginSearchForQuery: (NSString*) query {
	[busyIndicator setHidden:NO];
	[self showOverlay];
	[xsHelper searchResourcesWithQuery: query];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)sender {
	[sender setShowsCancelButton:YES animated:YES];
	resultsTableView.allowsSelection = NO;
	resultsTableView.scrollEnabled = NO;
	[self showOverlay];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)sender {
	[sender setShowsCancelButton:NO animated:YES];
	resultsTableView.allowsSelection = YES;
	resultsTableView.scrollEnabled = YES;
	[sender resignFirstResponder];
	[self hideOverlay];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)sender {
	[self beginSearchForQuery: sender.text];
	[sender setShowsCancelButton:NO animated:YES];
	resultsTableView.allowsSelection = YES;
	resultsTableView.scrollEnabled = YES;
	[sender resignFirstResponder];
}

@end
