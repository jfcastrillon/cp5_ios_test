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
#import "AdvancedSearchViewController.h"
#import "NetworkManager.h"


@implementation SearchViewController
@synthesize resultsTableView;
@synthesize searchBar;
@synthesize busyIndicator;
@synthesize dimmingOverlay;
@synthesize searchResults;
@synthesize loadMoreCell;
@synthesize mapView;

- (void) awakeFromNib {
	[super awakeFromNib];
	
	noResultsFound = NO;
}

- (void) showOverlay {
    
    CGRect overlayFrame = dimmingOverlay.frame;
	if ([self tableHeaderVisible:resultsTableView]) {
        CGRect visibleRect; 
        visibleRect.origin = resultsTableView.contentOffset; 
        visibleRect.size = resultsTableView.contentSize; 
        CGRect headerRect = resultsTableView.tableHeaderView.frame;
        overlayFrame.origin.y = headerRect.size.height - visibleRect.origin.y;
	} else {
        overlayFrame.origin.y = 0;
	}
	
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
	dimmingOverlay.hidden = NO;
	dimmingOverlay.alpha  = 0.7f;
}


- (void) hideOverlay {

	CGRect overlayFrame = dimmingOverlay.frame;
	if ([self tableHeaderVisible:resultsTableView]) {
		overlayFrame.origin.y = 44;
	} else {
		overlayFrame.origin.y = 0;
	}
	
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

- (IBAction) backgroundTap:(id)sender {
	if([searchBar isFirstResponder]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            self.resultsTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        }
		[self.navigationController setNavigationBarHidden:NO animated:YES];
		[searchBar setShowsCancelButton:NO animated:YES];
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

	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Advanced" 
																			  style:UIBarButtonItemStylePlain target:self action:@selector(advanced:)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" 
																			  style:UIBarButtonItemStylePlain target:self action:@selector(map:)];

	mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
	mapView.delegate = self;

	// Observe the notifications for completed search results
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didReceiveSearchResults:) name:@"SearchResultsReceived" object: xsHelper];
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didReceiveMoreSearchResults:) name:@"SearchResultsAppended" object: xsHelper];
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(searchRequestFailed:) name:@"SearchRequestFailed" object: xsHelper];
		
    [super viewDidLoad];
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
	self.searchBar = nil;
	self.resultsTableView = nil;
	self.busyIndicator = nil;
	self.dimmingOverlay = nil;
	self.loadMoreCell = nil;
	self.mapView = nil;
}

- (void)dealloc {
	[searchResults release];
	[resultsTableView release];
	[searchBar release];
	[busyIndicator release];
	[dimmingOverlay release];
	[loadMoreCell release];
	mapView.delegate = nil;
	[mapView release];
    [super dealloc];
}

-(BOOL)tableHeaderVisible:(UITableView *)tableView { 
	CGRect headerRect = tableView.tableHeaderView.frame; 
	CGRect visibleRect; 
	visibleRect.origin = tableView.contentOffset; 
	visibleRect.size = tableView.contentSize; 
	if(visibleRect.origin.x >= (headerRect.origin.x + headerRect.size.width)) { return NO; } 
	if(visibleRect.origin.y >= (headerRect.origin.y + headerRect.size.height)) { return NO; } 
	if(headerRect.origin.x >= (visibleRect.origin.x + visibleRect.size.width)) { return NO; } 
	if(headerRect.origin.y >= (visibleRect.origin.y + visibleRect.size.height)) { return NO; } return YES; 
}

- (void) viewWillAppear:(BOOL)animated {
    if([locationManager isLocationEnabled])
		[searchBar setShowsScopeBar:YES];
	else {
		[searchBar setShowsScopeBar: NO];
		[searchBar setSelectedScopeButtonIndex: 0]; // Only allow relevancy if the location services are disabled
	}
	[searchBar sizeToFit];
	[resultsTableView reloadData];
	if ([xsHelper isSearching]) {
		[self showOverlay];
		[busyIndicator setHidden:NO];
		[busyIndicator startAnimating];
	}
    [super viewWillAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
	if(isLoading)
		[[NetworkManager sharedInstance] hideNetworkActivityIndicator];
	[super viewDidDisappear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) zoomToFitMapAnnotations {
    if([mapView.annotations count] == 0)
        return;
	
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
	
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
	
    for (CPMapAnnotation* annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
		
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
	}
	
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
	
    region = [mapView regionThatFits:region];
    
    // Try to protect against new Apple region bug
    if (region.span.latitudeDelta > 179) {
        region.span.latitudeDelta = 179;
    }
    if (region.span.longitudeDelta > 359) {
        region.span.longitudeDelta = 359;
    }
    
    [mapView setRegion:region animated:YES];
}

- (void) reloadMapView {
	[mapView removeAnnotations:mapView.annotations];
	for (int i = 0; i < [searchResults count]; i++) {
		CPMResource* resource = [searchResults objectAtIndex:i];
		if ([resource longitude] != nil) {
			CLLocationCoordinate2D location;
			
			location.latitude=[resource.latitude doubleValue];
			location.longitude=[resource.longitude doubleValue];
			
			CPMapAnnotation *annotation = [[CPMapAnnotation alloc] initWithCoordinate:location andTitle:[resource name] andResourceId:[resource resourceId]];
			[mapView addAnnotation:annotation];
			[annotation release];
		}
	}
	[self zoomToFitMapAnnotations];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentResource"];
    annView.pinColor = MKPinAnnotationColorGreen;

    UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    annView.rightCalloutAccessoryView = advertButton;

    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);

    return [annView autorelease];
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	// Change to other view before loading this?
	ResourceDetailViewController *detailViewController = [[ResourceDetailViewController alloc] initWithNibName:@"ResourceDetailViewController" bundle:[NSBundle mainBundle]];
	
	[self.navigationController pushViewController:detailViewController animated:YES];
	
	[detailViewController release];
	
	[xsHelper cancelAllOperations];
	[xsHelper loadResourceDetails: [(CPMapAnnotation*)view.annotation resourceId]];
}

- (void) didReceiveSearchResults: (NSNotification*) notification {
	self.searchResults = [xsHelper searchResults];
	
	[busyIndicator setHidden:YES];
	if ([[[xsHelper lastSearchResultSet] totalCount] intValue] == 0){
		noResultsFound = YES;
		[resultsTableView reloadData];
		[resultsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
		[self hideOverlay];
		[self reloadMapView];
	} else {
		noResultsFound = NO;
		[resultsTableView setHidden: NO];

		[resultsTableView reloadData];
		[resultsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
		[resultsTableView scrollRectToVisible:CGRectMake(0, 44, 1, 1) animated:NO];
        [self hideOverlay];
		[self reloadMapView];
	}

    NSDictionary* previousParameters = [xsHelper lastQueryParams];
	if (previousParameters != nil) {
        [self.navigationItem.leftBarButtonItem setTitle:@"Refine"];
        if ([previousParameters objectForKey:kXSQueryNatural] == nil) {
            [self setSearchBarText:@"(Advanced Search)"];
			if ([previousParameters objectForKey:kXSSortByDistance] == nil && [searchBar selectedScopeButtonIndex] == 1) { 
	            [searchBar setSelectedScopeButtonIndex:0]; 
	        }
        }
    }
}

- (void) mapViewWillStartLoadingMap:(MKMapView *)mapView {
	[[NetworkManager sharedInstance]showNetworkActivityIndicator];
	isLoading = YES;
	
}

- (void) mapViewDidFinishLoadingMap:(MKMapView *)mapView {
	[[NetworkManager sharedInstance]hideNetworkActivityIndicator];
	isLoading = NO;
}

- (void) didReceiveMoreSearchResults: (NSNotification*) notification {
	self.searchResults = [xsHelper searchResults];
	isLoadingMore = NO;
	[loadMoreCell.activityIndicator setHidden:YES];

	[resultsTableView reloadData];
	[self reloadMapView];
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
	if (searchResults == nil) {
		return 0;
	} else if (noResultsFound) {
		return 3;
	} else {
		int remaining = [[[xsHelper lastSearchResultSet] totalCount] intValue] - [[[xsHelper lastSearchResultSet] count] intValue];
		return (remaining > 0) ? [searchResults count] + 1 : [searchResults count];		
	}
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	static NSString *ResourceSearchResultCellIdentifier = @"ResourceSearchResultCell";
	
	NSUInteger row = [indexPath row];
	

	if (noResultsFound) {
		UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		switch (row) {
			case 0:
			case 2:
				return cell;
				break;
			default:
				cell.textLabel.text = @"No results";
				cell.textLabel.textAlignment = UITextAlignmentCenter;
				cell.textLabel.textColor = [UIColor grayColor];
				return cell;
				break;
		}
	} else {
	
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
				cell.nameLabel.frame = CGRectMake(13, 7, 233, 22);
			} else {
				cell.distanceLabel.text = @"";
				cell.nameLabel.frame = CGRectMake(13, 7, 285, 22);
			}
			
			if ([resource isShelter] != nil && [[resource isShelter] boolValue]) {
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
}

- (void) setSearchBarText:(NSString *)text {
	searchBar.text = text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
	return kTableViewRowHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = [indexPath row];
	
	if (noResultsFound) {
		return;
	}
	
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
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	CGRect overlayFrame = dimmingOverlay.frame;
	overlayFrame.origin.y = 44;
	
	dimmingOverlay.frame = overlayFrame;	
	[CATransaction commit];
	[CATransaction flush];
	
	[self showOverlay];
	[busyIndicator setHidden:NO];
	[busyIndicator startAnimating];
	if ([searchBar selectedScopeButtonIndex] == 0) {
        if ([[searchBar text] isEqualToString:@"(Advanced Search)"]) {
            NSMutableDictionary* params = [[[XServicesHelper sharedInstance] lastQueryParams] mutableCopy];
            [params removeObjectForKey:kXSQueryReferenceLatitude];
            [params removeObjectForKey:kXSQueryReferenceLongitude];
            [params removeObjectForKey:kXSSortByDistance];
            [xsHelper searchResourcesWithQueryParams:params];
            [params release];
        } else {
            [xsHelper searchResourcesWithQuery: query];
        }
	} else {
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
    
    if ([[searchBar text] isEqualToString:@"(Advanced Search)"]) {
        NSMutableDictionary* params = [[[XServicesHelper sharedInstance] lastQueryParams] mutableCopy];
        [params setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:kXSQueryReferenceLatitude];
        [params setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:kXSQueryReferenceLongitude];
        [params setValue: @"true" forKey:kXSSortByDistance];
        [xsHelper searchResourcesWithQueryParams:params];
        [params release];
    } else {
        [xsHelper searchResourcesWithQuery:[searchBar text] forLatitude: [NSNumber numberWithDouble:location.coordinate.latitude] andLongitude: [NSNumber numberWithDouble:location.coordinate.longitude]];
    }
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
	
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.resultsTableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    }
	[resultsTableView scrollRectToVisible:[[resultsTableView tableHeaderView] bounds] animated:NO];
	resultsTableView.scrollEnabled = NO;
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[sender setShowsCancelButton:YES animated:YES];
	if([locationManager isLocationEnabled])
		[sender setShowsScopeBar:YES];
	else {
		[sender setShowsScopeBar: NO];
		[sender setSelectedScopeButtonIndex: 0]; // Only allow relevancy if the location services are disabled
	}

	[searchBar sizeToFit];
	resultsTableView.allowsSelection = NO;
	
	CGRect overlayFrame = dimmingOverlay.frame;
	overlayFrame.origin.y = 87;
	
	dimmingOverlay.frame = overlayFrame;
	[self showOverlay];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)sender {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.resultsTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[sender setShowsCancelButton:NO animated:YES];
	[searchBar sizeToFit];
	resultsTableView.allowsSelection = YES;
	resultsTableView.scrollEnabled = YES;
	[sender resignFirstResponder];
	[self hideOverlay];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)sender {
	[self beginSearchForQuery: sender.text];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.resultsTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[sender setShowsCancelButton:NO animated:YES];
	[searchBar sizeToFit];
	
	resultsTableView.allowsSelection = YES;
	resultsTableView.scrollEnabled = YES;
	[sender resignFirstResponder];
}

- (void) searchBar:(UISearchBar *)sender selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
 	if (sender.text == nil) { 
 	    sender.text = @""; 
 	} 
    [self beginSearchForQuery: sender.text];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.resultsTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[sender setShowsCancelButton:NO animated:YES];
	[searchBar sizeToFit];
	
	resultsTableView.allowsSelection = YES;
	resultsTableView.scrollEnabled = YES;
	[sender resignFirstResponder];
}

- (IBAction) advanced:(id)sender {
	AdvancedSearchViewController *advancedSearch = [[AdvancedSearchViewController alloc] initWithNibName:@"AdvancedSearchViewController" bundle:nil];
	UINavigationController *t = [[UINavigationController alloc] initWithRootViewController:advancedSearch];
	[self presentViewController:t animated:YES completion:nil];
	advancedSearch.delegate = self;
	[advancedSearch release];
	[t release];
}

- (IBAction) mapLoadMore:(id)sender {
	[loadMoreCell.activityIndicator setHidden:NO];
	[loadMoreCell.activityIndicator startAnimating];
	isLoadingMore = YES;
	[xsHelper loadMoreResults];
}

- (IBAction) map:(id)sender {
	UIView *map = mapView;
	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.3];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:resultsTableView.superview cache:YES];
	
    UIView *parent = resultsTableView.superview;
    [resultsTableView removeFromSuperview];
	
	map.frame = resultsTableView.frame;
    [parent addSubview:map];
	
    [UIView commitAnimations];	
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"List" 
																			  style:UIBarButtonItemStylePlain target:self action:@selector(list:)] autorelease];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Load More" 
																			 style:UIBarButtonItemStylePlain target:self action:@selector(mapLoadMore:)] autorelease];
	
	// Disable the Load More button if no search has yet been performed
	if ([xsHelper searchResults] == nil || [[xsHelper searchResults] count] == 0) {
		self.navigationItem.leftBarButtonItem.enabled = NO;
	}
}

- (IBAction) list:(id)sender {
	UIView *table = resultsTableView;
	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.3];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:mapView.superview cache:YES];
	
    UIView *parent = mapView.superview;
    [mapView removeFromSuperview];
	
    [parent insertSubview:table belowSubview:dimmingOverlay];
	
    [UIView commitAnimations];	
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" 
																			  style:UIBarButtonItemStylePlain target:self action:@selector(map:)];
	
    if ([xsHelper lastQueryParams]) {
          self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refine" 
																			 style:UIBarButtonItemStylePlain target:self action:@selector(advanced:)];
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Advanced" 
                                                                                 style:UIBarButtonItemStylePlain target:self action:@selector(advanced:)];
    }
}

@end
