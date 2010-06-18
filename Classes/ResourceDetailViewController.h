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
@class CPMResourceDetail;

@interface ResourceDetailViewController : UITableViewController <UITableViewDelegate, MFMailComposeViewControllerDelegate, UITableViewDataSource> {
	CPMResourceDetail *displayedResource;
	UILabel *nameLabel;
	UITableView *tableView;
	NSString *addressText;
}

@property (nonatomic, retain) CPMResourceDetail *displayedResource;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction) emailButtonPressed: (id) sender;
- (IBAction) favoriteButtonPressed: (id) sender;

- (void) updateDisplay;

@end
