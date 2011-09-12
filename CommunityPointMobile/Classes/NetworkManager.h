//
//  NetworkManager.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/22/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface NetworkManager : NSObject {
	Reachability* serviceReachability;
	Reachability* connectionReachability;
	
	
	NetworkStatus lastKnownServiceStatus;
	NetworkStatus lastKnownConnectionStatus;
	NSUInteger networkActivityIndicatorCount;
}

- (BOOL) isServiceReachable;
- (BOOL) isInternetConnectionAvailable;

- (void) showNetworkActivityIndicator;
- (void) hideNetworkActivityIndicator;

+ (NetworkManager*) sharedInstance;

@end
