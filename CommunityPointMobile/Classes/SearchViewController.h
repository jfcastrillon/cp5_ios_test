//
//  SearchViewController.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright 2010 Louisiana State University-Shreveport. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XServicesHelper;

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITextField *searchField;	
	XServicesHelper *xsHelper;
	NSArray* searchResults;
	UITableView* resultsTableView;
}

@property (nonatomic, retain) IBOutlet UITextField* searchField;
@property (nonatomic, retain) IBOutlet UITableView* resultsTableView;
@property (nonatomic, retain) NSArray* searchResults;



- (IBAction) backgroundTap:(id)sender;
- (IBAction) searchFieldDidFinish:(id)sender;
- (IBAction) mapButtonPressed:(id)sender;

@end
