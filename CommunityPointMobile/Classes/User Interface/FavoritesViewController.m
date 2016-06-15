//
//  FavoritesViewController.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "FavoritesViewController.h"
#import "CPMResource.h"
#import "CPMResourceDetail.h"
#import "CPMSearchResultSet.h"
#import "XServicesHelper.h"
#import "ResourceSearchResultCell.h"
#import "ResourceDetailViewController.h"


@implementation FavoritesViewController
@synthesize favorites;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];

	// Get singleton instance of the helper
	xsHelper = [XServicesHelper sharedInstance];
	
	self.favorites = [xsHelper favorites];
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	self.favorites = nil;
}

- (void) didReceiveProviderDetails:(NSNotification*) notification {
	ResourceDetailViewController *detailViewController = [[ResourceDetailViewController alloc] initWithNibName:@"ResourceDetailViewController" bundle:[NSBundle mainBundle]];
	
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController setDisplayedResource: [xsHelper currentResource]];
	
	[detailViewController release];
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	if(favorites == nil)
		return 0;
	else 
		return [favorites count];		
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

	NSDictionary* favorite = [favorites objectAtIndex:row];
	cell.nameLabel.text = [favorite objectForKey:@"name"];
	cell.addressLabel.text = [favorite objectForKey:@"address"];
	cell.distanceLabel.text = @"";
	cell.nameLabel.frame = CGRectMake(13, 7, 285, 22);
	if ([favorite objectForKey:@"shelterFlag"] != nil && [[favorite objectForKey:@"shelterFlag"] boolValue]) {
		[cell.bedImage setHidden:NO];
	} else {
		[cell.bedImage setHidden:YES];
	}
	
	if ([favorite objectForKey:@"accessibilityFlag"] != nil && [[favorite objectForKey:@"accessibilityFlag"] boolValue]) {
		[cell.handicapImage setHidden:NO];
	} else {
		[cell.handicapImage setHidden:YES];
	}
	[cell.activityIndicator setHidden:YES];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
	return kTableViewRowHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = [indexPath row];
	NSDictionary* favorite = [favorites objectAtIndex:row];
	
	// Change to other view before loading this?
	ResourceDetailViewController *detailViewController = [[ResourceDetailViewController alloc] initWithNibName:@"ResourceDetailViewController" bundle:[NSBundle mainBundle]];
	
	[self.navigationController pushViewController:detailViewController animated:YES];
	
	[detailViewController release];

	[xsHelper loadResourceDetails: [favorite objectForKey:@"resourceId"]];

}

// Override to support editing the table view.
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source.
		[xsHelper removeFavoriteAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
	}
}

- (void)dealloc {
	[favorites release];
    [super dealloc];
}


@end
