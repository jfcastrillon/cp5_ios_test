//
//  ResourceDetailViewController.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/4/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XServicesHelper.h"
#import "CPMResourceDetail.h"

@interface ResourceDetailViewController : UITableViewController <UIActionSheetDelegate> {
	CPMResourceDetail *displayedResource;
	UIButton *favoriteButton;
	UIButton *shareButton;
	UILabel *nameLabel;
	UIView *buttonContainer;
	UIView *loadingOverlay;
	NSString *addressText;
	XServicesHelper* xsHelper;
}

@property (nonatomic, retain) CPMResourceDetail *displayedResource;
@property (nonatomic, retain) IBOutlet UIButton *favoriteButton;
@property (nonatomic, retain) IBOutlet UIButton *shareButton;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIView *buttonContainer;
@property (nonatomic, retain) IBOutlet UIView *loadingOverlay;

- (IBAction) shareButtonPressed: (id) sender;
- (IBAction) favoriteButtonPressed: (id) sender;

- (void) updateDisplay;

@end
