//
//  SearchViewController.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationManager.h"
#import "ResourceSearchResultCell.h"
#import "CPMapAnnotation.h"

#define kTableViewRowHeight	66

@class XServicesHelper;
@class ResourceDetailViewController;
@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
	UISearchBar *searchBar;	
	XServicesHelper *xsHelper;
	LocationManager *locationManager;
	NSArray* searchResults;
	UITableView* resultsTableView;
	UIActivityIndicatorView *busyIndicator;
	UIView *dimmingOverlay;
	ResourceSearchResultCell *loadMoreCell;
	UILabel *noResultsLabel;
	BOOL isLoadingMore;
	MKMapView *mapView;
}

@property (nonatomic, retain) IBOutlet UISearchBar* searchBar;
@property (nonatomic, retain) IBOutlet UITableView* resultsTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* busyIndicator;
@property (nonatomic, retain) IBOutlet UIView* dimmingOverlay;
@property (nonatomic, retain) NSArray* searchResults;
@property (nonatomic, retain) IBOutlet XServicesHelper* xsHelper;
@property (nonatomic, retain) ResourceSearchResultCell* loadMoreCell;
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) IBOutlet UIView* noResultsView;

- (IBAction) backgroundTap:(id)sender;

@end
