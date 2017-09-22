//
//  HomeViewController.h
//  CommunityPointMobile
//
//  Created by Matthew Baker on 9/29/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "XServicesHelper.h"

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AboutViewControllerDelegate> {
	UITableView* tableView;
	UIButton* helpVideo;
	UIButton* website;
	XServicesHelper *xsHelper;
    IBOutlet UIButton *commonSearches;
	AboutViewController *aboutViewController;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UIButton* helpVideo;
@property (nonatomic, retain) IBOutlet UIButton* website;
@property (nonatomic, retain) IBOutlet UIButton* commonSearches;
@property (nonatomic, retain) IBOutlet AboutViewController* aboutViewController;

- (IBAction) videoButtonPressed: (id) sender;
- (IBAction) websiteButtonPressed: (id) sender;
- (IBAction) commonSearchesButtonPressed: (id) sender;
- (IBAction) showAboutView;

@end
