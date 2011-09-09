//
//  ResourceMapViewController.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/11/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CPMResourceDetail.h"
#import "NetworkManager.h"
#import "LocationManager.h"

#define DEFAULT_MAP_LONGITUDE_DELTA_IN_DEGREES 0.025
#define DEFAULT_MAP_LATITUDE_DELTA_IN_DEGREES 0.025

@interface ResourceMapViewController : UIViewController <MKMapViewDelegate> {
	MKMapView *mapView;
	CPMResource *displayedResource;
	BOOL isLoading;
	LocationManager *locationManager;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CPMResource *displayedResource;

- (IBAction) directions:(id)sender;

@end
