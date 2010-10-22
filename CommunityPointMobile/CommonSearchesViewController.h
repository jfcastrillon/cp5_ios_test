//
//  CommonSearchesViewController.h
//  CommunityPointMobile
//
//  Created by Matthew Baker on 10/22/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XServicesHelper;
@interface CommonSearchesViewController : UITableViewController {
	XServicesHelper *xsHelper;
	NSArray* commonSearches;
}

@property (nonatomic, retain) NSArray* commonSearches;

@end
