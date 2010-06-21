//
//  FavoritesViewController.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTableViewRowHeight	66

@class XServicesHelper;
@class ResourceDetailViewController;
@interface FavoritesViewController : UITableViewController {
	XServicesHelper *xsHelper;
	NSOperationQueue *operationQueue;
	NSMutableArray* favorites;
	UITableView* favoritesTableView;
}

@property (nonatomic, retain) IBOutlet UITableView* favoritesTableView;
@property (nonatomic, retain) NSMutableArray* favorites;

@end
