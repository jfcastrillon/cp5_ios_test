//
//  ResourceMapViewController.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/11/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "ResourceMapViewController.h"
#import "CPMapAnnotation.h"

@implementation ResourceMapViewController

@synthesize mapView, displayedResource;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidDisappear:(BOOL)animated {
	if(isLoading)
		[[NetworkManager sharedInstance] hideNetworkActivityIndicator];
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload {
    mapView = nil;
	displayedResource = nil;
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated {
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=DEFAULT_MAP_LATITUDE_DELTA_IN_DEGREES;
	span.longitudeDelta=DEFAULT_MAP_LONGITUDE_DELTA_IN_DEGREES;
	
	CLLocationCoordinate2D location;
	
	location.latitude=[displayedResource.latitude doubleValue];
	location.longitude=[displayedResource.longitude doubleValue];
	region.span=span;
	region.center=location;
	
	[mapView setRegion:region animated:YES];
	CPMapAnnotation *annotation = [CPMapAnnotation initWithCoordinate:location andTitle:[displayedResource name]];
	[mapView addAnnotation:annotation];
	
	[super viewDidAppear:animated];
}

- (void) mapViewWillStartLoadingMap:(MKMapView *)mapView {
	[[NetworkManager sharedInstance]showNetworkActivityIndicator];
	isLoading = YES;
	
}

- (void) mapViewDidFinishLoadingMap:(MKMapView *)mapView {
	[[NetworkManager sharedInstance]hideNetworkActivityIndicator];
	isLoading = NO;
}


- (void)dealloc {
	[mapView release];
	[displayedResource release];
    [super dealloc];
}


@end
