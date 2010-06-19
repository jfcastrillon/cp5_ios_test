//
//  ResourceDetailViewController.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/4/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "XServicesHelper.h"
#import "CPMResourceDetail.h"

@interface ResourceDetailViewController : UITableViewController <UITableViewDelegate, MFMailComposeViewControllerDelegate, UITableViewDataSource> {
	CPMResourceDetail *displayedResource;
	UILabel *nameLabel;
	UIView *buttonContainer;
	UIView *loadingOverlay;
	UITableView *tableView;
	NSString *addressText;
	XServicesHelper* xsHelper;
}

@property (nonatomic, retain) CPMResourceDetail *displayedResource;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIView *buttonContainer;
@property (nonatomic, retain) IBOutlet UIView *loadingOverlay;

- (IBAction) emailButtonPressed: (id) sender;
- (IBAction) favoriteButtonPressed: (id) sender;

- (void) updateDisplay;

@end
