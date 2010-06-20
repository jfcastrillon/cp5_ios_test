//
//  CommunityPointMobileAppDelegate.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright Bowman Systems, LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XServicesHelper;
@interface CommunityPointMobileAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
	XServicesHelper *xsHelper;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet XServicesHelper* xsHelper;

@end

