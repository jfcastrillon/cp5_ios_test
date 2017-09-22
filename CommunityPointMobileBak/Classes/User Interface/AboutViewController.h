//
//  AboutViewController.h
//  CommunityPointMobile
//
//  Created by John Cannon on 7/29/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AboutViewControllerDelegate <NSObject>

//TODO: Rename this, it's confusing
- (void) aboutViewShouldDismiss;

@end

@class SearchViewController;
@interface AboutViewController : UIViewController {
	id<AboutViewControllerDelegate> delegate;
	UIWebView *aboutHtmlView;
}

@property (nonatomic, retain) IBOutlet id<AboutViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIWebView *aboutHtmlView;

- (IBAction) dismiss;

@end
