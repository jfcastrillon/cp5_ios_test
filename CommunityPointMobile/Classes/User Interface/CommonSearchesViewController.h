//
//  CommonSearchesViewController.h
//  CommunityPointMobile
//
//  Created by Matthew Baker on 10/22/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPMCommonSearch.h"

@class XServicesHelper;
@interface CommonSearchesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	XServicesHelper *xsHelper;
	NSArray* commonSearches;
	UITableView* tableView;
	UIActivityIndicatorView *busyIndicator;
	UIView *dimmingOverlay;
	BOOL isLoading;
}

@property (nonatomic, retain) NSArray* commonSearches;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* busyIndicator;
@property (nonatomic, retain) IBOutlet UIView* dimmingOverlay;

- (void)setLoading: (BOOL)loading;

@end
