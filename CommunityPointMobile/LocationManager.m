//
//  LocationManager.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/28/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "LocationManager.h"


NSString* const LocationManagerFoundLocationNotification = @"LocationManagerFoundLocation";
NSString* const LocationManagerFindLocationFailedNotification = @"LocationManagerFindLocationFailed";
NSString* const kLocationManagerCurrentLocation = @"LocationManagerCurrentLocation";
NSString* const kLocationManagerError = @"LocationManagerError";

@implementation LocationManager

- (id) init {
	self = [super init];
	if(self == nil) return nil;
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	
	return self;
}

- (void) dealloc {
	[locationManager release];
	[super dealloc];
}

- (BOOL) isLocationEnabled {
	return locationManager.locationServicesEnabled;
}

- (void) startFindingCurrentLocation {
	[locationManager startUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:LocationManagerFoundLocationNotification object:self userInfo:[NSDictionary dictionaryWithObject:newLocation forKey:kLocationManagerCurrentLocation]]];
	[locationManager stopUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:LocationManagerFindLocationFailedNotification object:self userInfo:[NSDictionary dictionaryWithObject:error forKey:kLocationManagerError]]];
	[locationManager stopUpdatingLocation];
}

// Below implements the singleton pattern for this class (from examples online)
static LocationManager* sharedManagerInstance = nil;

+ (LocationManager*) sharedInstance {
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
