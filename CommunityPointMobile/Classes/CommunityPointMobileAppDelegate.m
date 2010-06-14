//
//  CommunityPointMobileAppDelegate.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright Louisiana State University-Shreveport 2010. All rights reserved.
//

#import "CommunityPointMobileAppDelegate.h"

@implementation CommunityPointMobileAppDelegate

@synthesize window;
@synthesize rootController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
	[window addSubview:rootController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[rootController release];
    [window release];
    [super dealloc];
}



@end
