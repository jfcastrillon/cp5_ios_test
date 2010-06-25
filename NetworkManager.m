//
//  NetworkManager.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/22/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "NetworkManager.h"


@implementation NetworkManager


- (id) init {
	if(!(self = [super init])) return nil;
	
	// Observe network reachability changes
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	
	// Network reachability
	serviceReachability = [[Reachability reachabilityWithHostName: @"syncpoint.bowmansystems.com"] retain];
	connectionReachability = [[Reachability reachabilityForInternetConnection] retain];
	
	lastKnownConnectionStatus = NotReachable;
	lastKnownServiceStatus = NotReachable;
	
	[connectionReachability startNotifier];
	[serviceReachability startNotifier];
	
	networkActivityIndicatorCount = 0;
	
	return self;
}

- (void) reachabilityChanged: (NSNotification*) notification {
	Reachability *reach = [notification object];
	NetworkStatus status = [reach currentReachabilityStatus];
	if(reach == connectionReachability || status != NotReachable) {
		lastKnownConnectionStatus = status;
	} else if (reach == serviceReachability || status == NotReachable) {
		lastKnownServiceStatus = status;
	}
	
	NSString* netStatString;
	switch (status) {
		case NotReachable:
			netStatString = @"Not reachable";
			break;
		case ReachableViaWiFi:
			netStatString = @"Reachable via Wi-Fi";
			break;
		case ReachableViaWWAN:
			netStatString = @"Reachable via WWAN";
			break;
		default:
			netStatString = @"????";
			break;
	}
	
	NSLog(@"XS Reachability: %@", netStatString);
}


- (BOOL) isServiceReachable {
	return lastKnownServiceStatus != NotReachable;
}

- (BOOL) isInternetConnectionAvailable {
	return lastKnownConnectionStatus != NotReachable;
}

- (void) showNetworkActivityIndicator{
	if(networkActivityIndicatorCount == 0)
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	networkActivityIndicatorCount++;
}

- (void) hideNetworkActivityIndicator {
	networkActivityIndicatorCount--;
	if(networkActivityIndicatorCount == 0)
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

// Below implements the singleton pattern for this class (from examples online)
static NetworkManager* sharedManagerInstance = nil;

+ (NetworkManager*) sharedInstance {
	@synchronized(self){
		if (sharedManagerInstance == nil) {
			sharedManagerInstance = [[self alloc] init];
		}
	}
	return sharedManagerInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedManagerInstance == nil) {
            sharedManagerInstance = [super allocWithZone:zone];
            return sharedManagerInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //never let this be released;
}

- (void)release {
    //prevent release
}

- (id)autorelease {
    return self;
}


@end
