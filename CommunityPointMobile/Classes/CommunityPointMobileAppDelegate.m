//
//  CommunityPointMobileAppDelegate.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright Bowman Systems, LLC 2010. All rights reserved.
//

#import "CommunityPointMobileAppDelegate.h"
#import "XServicesHelper.h"
#import "Reachability.h"
#import "TVOutManager.h"

@implementation CommunityPointMobileAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize xsHelper;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[window addSubview: tabBarController.view];
    [window makeKeyAndVisible];
	
	// Get singleton instance of the helper
	xsHelper = [XServicesHelper sharedInstance];
	[[TVOutManager sharedInstance] startTVOut];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	/*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */

	[xsHelper emptyCaches];
	[xsHelper persistFavorites];
}

- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[xsHelper emptyCaches];
}

- (void) applicationWillTerminate:(UIApplication *)application {
	[xsHelper persistFavorites];
}

- (void)dealloc {
	[tabBarController release];
    [window release];
	[xsHelper release];
    [super dealloc];
}

@end
