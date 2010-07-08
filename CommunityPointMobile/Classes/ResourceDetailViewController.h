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
#import <MessageUI/MFMessageComposeViewController.h>
#import "XServicesHelper.h"
#import "CPMResourceDetail.h"

@interface ResourceDetailViewController : UIViewController <UITableViewDataSource, UITableViewDataSource, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {
	CPMResourceDetail *displayedResource;
	UIButton *favoriteButton;
	UIButton *shareButton;
	UILabel *nameLabel;
	UIView *buttonContainer;
	UIView *loadingOverlay;
	UITableView* tableView;
	NSString *addressText;
	XServicesHelper* xsHelper;
	
	//Section indexes
	NSUInteger locationSectionIndex;
	NSUInteger detailsSectionIndex;
	NSUInteger servicesSectionIndex;
	NSUInteger generalInfoSectionIndex;
	
	//Location
	NSUInteger addressCellIndex;
	NSUInteger phoneCellIndex;
	NSUInteger urlCellIndex;
	
	// General Information
	NSUInteger hoursCellIndex;
	NSUInteger programFeesCellIndex;
	NSUInteger languagesCellIndex;
	NSUInteger eligibilityCellIndex;
	NSUInteger intakeProcedureCellIndex;
	NSUInteger accessibilityCellIndex;
	NSUInteger shelterCellIndex;
	NSUInteger shelterRequirementsCellIndex;
}

@property (nonatomic, retain) CPMResourceDetail *displayedResource;
@property (nonatomic, retain) IBOutlet UIButton *favoriteButton;
@property (nonatomic, retain) IBOutlet UIButton *shareButton;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIView *buttonContainer;
@property (nonatomic, retain) IBOutlet UIView *loadingOverlay;
@property (nonatomic, retain) IBOutlet UITableView* tableView;

- (IBAction) shareButtonPressed: (id) sender;
- (IBAction) favoriteButtonPressed: (id) sender;

- (void) emailResource;
- (void) smsResource;
- (void) updateDisplay;
- (void) displayComposerSheet;
- (void) launchMailAppOnDevice;

- (NSInteger) numberOfRowsInSection:(NSInteger)section;

@end
