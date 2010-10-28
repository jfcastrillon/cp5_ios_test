//
//  AboutViewController.h
//  CommunityPointMobile
//
//  Created by John Cannon on 7/29/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchViewController;
@interface AboutViewController : UIViewController {
	id delegate;
	UIWebView *aboutHtmlView;
}

@property (nonatomic, retain) IBOutlet id delegate;
@property (nonatomic, retain) IBOutlet UIWebView *aboutHtmlView;

- (IBAction) dismiss;

@end
