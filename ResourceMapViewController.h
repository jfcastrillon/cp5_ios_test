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

@interface ResourceMapViewController : UIViewController {
	MKMapView *mapView;
	CPMResource *displayedResource;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CPMResource *displayedResource;

@end
