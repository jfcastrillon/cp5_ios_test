//
//  LocationManager.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/28/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString* const LocationManagerFoundLocationNotification;
extern NSString* const LocationManagerFindLocationFailedNotification;
extern NSString* const kLocationManagerCurrentLocation;
extern NSString* const kLocationManagerError;

@interface LocationManager : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
}

- (BOOL) isLocationEnabled;

- (void) startFindingCurrentLocation;

+ (LocationManager*) sharedInstance;

@end
