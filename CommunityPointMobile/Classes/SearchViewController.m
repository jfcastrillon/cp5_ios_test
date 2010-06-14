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
#import "XServicesHelper.h"
#import "ResourceSearchResultCell.h"
#import "ResourceDetailViewController.h"


@implementation SearchViewController
@synthesize resultsTableView;
@synthesize searchBar;
@synthesize busyIndicator;
@synthesize dimmingOverlay;
@synthesize searchResults;

- (IBAction) backgroundTap:(id)sender {
	[searchBar resignFirstResponder];
}

- (IBAction) mapButtonPressed:(id)sender {
	// TODO: Implement mapping
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mapping Performed" message:@"You tried to map results.  Unfortunately this isn't implemented yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	if (xsHelper == nil) {
		xsHelper = [[XServicesHelper alloc] initWithBaseUrl:@"http://syncpoint.bowmansystems.com/xs/1.0/index.php" andPublicKey:@"B47182694EA9167F4A6320B775636039"];
		[xsHelper setDelegate: self];
	}
	
	//[xsHelper retrieveProviderCount];
	//[xsHelper searchResourcesWithQuery: @"food"];
	
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
	self.searchBar = nil;
	self.searchResults = nil;
	self.resultsTableView = nil;
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


- (void) didReceiveSearchResults:(NSArray*) results {
	self.searchResults = results;
	[resultsTableView setHidden: NO];
	[busyIndicator setHidden:YES];
	[self hideOverlay];
	[resultsTableView reloadData];
}

- (void) didReceiveProviderDetails:(CPMResourceDetail*)resource {
	ResourceDetailViewController *detailViewController = [[ResourceDetailViewController alloc] initWithNibName:@"ResourceDetailViewController" bundle:[NSBundle mainBundle]];
	
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController setDisplayedResource: resource];
	
	
	[detailViewController release];
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
	
	//Build address line
	NSMutableString *addressLine = [[NSMutableString alloc] init];
	NSMutableArray *addressParts = [[NSMutableArray alloc] init];

	if(resource.address1 != nil)
		[addressParts addObject: [resource address1]];
	if(resource.city != nil)
		[addressParts addObject: [resource city]];
	if(resource.state != nil)
		[addressParts addObject: [resource state]];
	
	for(int i = 0; i < [addressParts count]; i++) {
		NSString* part = [addressParts objectAtIndex:i];
		if(part != nil) {
			part = [part stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if([part length] > 0) {
				[addressLine appendString: part];
				if(i+1 < [addressParts count])
					[addressLine appendString: @", "];
			}
		}
	}
	
	cell.addressLabel.text = addressLine;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
	return kTableViewRowHeight;
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = [indexPath row];
	CPMResource *resource = [searchResults objectAtIndex:row];
	//ResourceDetailViewController *detailViewController = [[NSBundle mainBundle] loadNibNamed:@"ResourceDetailViewController" owner:self options:nil];
	

	[xsHelper retrieveResourceDetails: [resource resourceId]];
	
	
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

/*- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	[self beginSearchForQuery: searchBar.text];
	[searchBar resignFirstResponder];
}*/

- (void) searchBarSearchButtonClicked:(UISearchBar *)sender {
	[self beginSearchForQuery: sender.text];
	[sender setShowsCancelButton:NO animated:YES];
	resultsTableView.allowsSelection = YES;
	resultsTableView.scrollEnabled = YES;
	[sender resignFirstResponder];
}

@end
