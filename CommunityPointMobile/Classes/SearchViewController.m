//
//  SearchViewController.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "SearchViewController.h"
#import "CPMResource.h"
#import "XServicesHelper.h"


@implementation SearchViewController
@synthesize resultsTableView;
@synthesize searchField;
@synthesize searchResults;

- (IBAction) backgroundTap:(id)sender {
	[searchField resignFirstResponder];
}

- (IBAction) searchFieldDidFinish:(id)sender {
	// TODO: Implement search method
	//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search Performed" message:@"You performed a search.  Unfortunately this isn't implemented yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//[alert show];
	//[alert release];
	//[self doSearch: searchField.text];
	//if([xsHelper busy])
	//	[xsHelper cancel];
	[xsHelper searchResourcesWithQuery:searchField.text];
}

- (IBAction) mapButtonPressed:(id)sender {
	// TODO: Implement mapping
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mapping Performed" message:@"You tried to map results.  Unfortunately this isn't implemented yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	if (xsHelper == nil) {
		xsHelper = [[XServicesHelper alloc] initWith:@"" andPublicKey:@""];
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
	self.searchField = nil;
	self.searchResults = nil;
	self.resultsTableView = nil;
}


- (void)dealloc {
	[searchResults release];
    [super dealloc];
}

- (void) didReceiveProviderCount:(NSDictionary*) results {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Provider Count worked?!?!?" message:@"You cheeky bastard!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void) didReceiveSearchResults:(NSArray*) results {
	/*NSString* resultCount = [[[results objectForKey: @"resources"] objectForKey: @"total"] stringValue];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search worked?!?!?" message:[[NSString alloc] initWithFormat:@"You cheeky bastard!  You found %@ resources", resultCount] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];*/
	self.searchResults = results;
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
	static NSString *SearchResultsTableIdentifier = @"SearchResultsTableIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchResultsTableIdentifier];
	if(cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchResultsTableIdentifier] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	//cell.textLabel.text = [[searchResults objectAtIndex:row] objectForKey: @"name"];
	cell.textLabel.text = [[searchResults objectAtIndex:row] name];
	return cell;
}

@end
