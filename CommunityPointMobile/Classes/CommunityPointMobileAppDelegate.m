//
//  CommunityPointMobileAppDelegate.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright Bowman Systems, LLC 2010. All rights reserved.
//

#import "CommunityPointMobileAppDelegate.h"

@implementation CommunityPointMobileAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	[window addSubview: tabBarController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[tabBarController release];
    [window release];
    [super dealloc];
}



@end
