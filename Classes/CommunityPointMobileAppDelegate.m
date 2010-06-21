//
//  CommunityPointMobileAppDelegate.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright Bowman Systems, LLC 2010. All rights reserved.
//

#import "CommunityPointMobileAppDelegate.h"
#import "XServicesHelper.h"

@implementation CommunityPointMobileAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize xsHelper;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[window addSubview: tabBarController.view];
    [window makeKeyAndVisible];
	
	// Get singleton instance of the helper
	xsHelper = [XServicesHelper sharedInstance];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Save the Favorites
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Favorites" ofType:@"plist"];
	[[xsHelper favorites] writeToFile:path atomically:YES];
}

- (void)dealloc {
	[tabBarController release];
    [window release];
	[xsHelper release];
    [super dealloc];
}

@end
