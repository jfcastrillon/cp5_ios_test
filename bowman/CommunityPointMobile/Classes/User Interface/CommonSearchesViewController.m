//
//  CommonSearchesViewController.m
//  CommunityPointMobile
//
//  Created by Matthew Baker on 10/22/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CommonSearchesViewController.h"
#import "XServicesHelper.h"

@implementation CommonSearchesViewController
@synthesize commonSearches;
@synthesize tableView;
@synthesize busyIndicator;
@synthesize dimmingOverlay;

- (void) showOverlay {
	CATransition *animation = [CATransition animation];
	[animation setType: kCATransitionFade];
	[animation setDuration: 0.3];
	[animation setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[dimmingOverlay layer] addAnimation:animation forKey:@"overlayTransition"];
	dimmingOverlay.hidden = NO;
	dimmingOverlay.alpha  = 0.7f;
}

- (void) setLoading: (BOOL)loading {
	isLoading = loading;
}

- (void) hideOverlay {
	CGRect overlayFrame = dimmingOverlay.frame;
	overlayFrame.origin.y = 0;

	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	[dimmingOverlay setFrame: overlayFrame];
	[CATransaction commit];
	[CATransaction flush];
	
	CATransition *animation = [CATransition animation];
	[animation setType: kCATransitionFade];
	[animation setDuration: 0.3];
	[animation setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[dimmingOverlay layer] addAnimation:animation forKey:@"overlayTransition"];
	dimmingOverlay.hidden = YES;
	dimmingOverlay.alpha  = 0.0f;
}

- (void) didReceiveCommonSearches: (NSNotification*) notification {
	self.commonSearches = [xsHelper commonSearches];
	[self setLoading:NO];
	[busyIndicator setHidden:YES];
	[self hideOverlay];
	
	[self.tableView reloadData];
    
    if (self.commonSearches && [self.commonSearches count] > 0)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void) commonSearchesRequestFailed: (NSNotification*) notification {
	[self setLoading:NO];
	[busyIndicator setHidden: YES];
	[self hideOverlay];

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
	
	if (isLoading) {
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
		CGRect overlayFrame = dimmingOverlay.frame;
		overlayFrame.origin.y = 0;
		
		dimmingOverlay.frame = overlayFrame;	
		[CATransaction commit];
		[CATransaction flush];
		
		[self showOverlay];
		[busyIndicator setHidden:NO];
		[busyIndicator startAnimating];
	}
	
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"CommonSearchesReceived" object:xsHelper];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"CommonSearchesRequestFailed" object:xsHelper];

    [super viewWillDisappear:animated];
}

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
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

	CPMCommonSearch* cs = [commonSearches objectAtIndex:row];
	cell.textLabel.text = [cs name];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	NSUInteger row = [indexPath row];
	CPMCommonSearch* cs = [commonSearches objectAtIndex:row];
	[xsHelper searchResourcesWithQueryParams:[cs queryParameters]];

    [[self.tabBarController.viewControllers objectAtIndex:1] popToRootViewControllerAnimated:NO];
	[self.tabBarController setSelectedIndex:1];
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

	self.tableView = nil;
	self.busyIndicator = nil;
	self.dimmingOverlay = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[commonSearches release];
	[tableView release];
	[busyIndicator release];
	[dimmingOverlay release];
    [super dealloc];
}


@end

