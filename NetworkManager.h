//
//  NetworkManager.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/22/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkManager : NSObject {
	NSOperationQueue* operationQueue;
	Reachability* serviceReachability;
	Reachability* connectionReachability;
	
	
	NetworkStatus lastKnownServiceStatus;
	NetworkStatus lastKnownConnectionStatus;
}

- (BOOL) isServiceReachable;
- (BOOL) isInternetConnectionAvailable;

+ (NetworkManager*) sharedInstance;

@end
