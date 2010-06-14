//
//  CommunityPointMobileAppDelegate.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright Louisiana State University-Shreveport 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityPointMobileAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *rootController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *rootController;

@end

