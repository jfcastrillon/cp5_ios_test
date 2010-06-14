//
//  ResourceDetailViewController.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/4/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPMResourceDetail;

@interface ResourceDetailViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	CPMResourceDetail *displayedResource;
	UILabel *nameLabel;
	UITableView *tableView;
	NSString *addressText;
}

@property (nonatomic, retain) CPMResourceDetail *displayedResource;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void) updateDisplay;

@end
