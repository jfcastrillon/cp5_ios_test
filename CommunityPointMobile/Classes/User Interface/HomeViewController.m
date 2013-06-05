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

@synthesize tableView, website, helpVideo;
@synthesize aboutViewController;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	// Get singleton instance of the helper
	xsHelper = [XServicesHelper sharedInstance];
	[self.navigationController setNavigationBarHidden:YES animated:NO];

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.tableView = nil;
	self.aboutViewController = nil;
	
    [super viewDidUnload];
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
	[aboutViewController release];
	
    [super dealloc];
}

- (IBAction) videoButtonPressed: (id) sender {
	NSString *url = @"tel://1-877-211-8661";
	//NSString *url = [[[SettingsHelper sharedInstance] settings] objectForKey:@"helpVideo"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
}

- (IBAction) websiteButtonPressed: (id) sender {
	NSString *url = [[[SettingsHelper sharedInstance] settings] objectForKey:@"website"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
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
