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
    locationManager = [LocationManager sharedInstance];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Get Directions"
                                                                              style:UIBarButtonItemStylePlain target:self action:@selector(directions:)];
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
    if ([displayedResource address1] != nil) {
        NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@", displayedResource.address1,displayedResource.city,displayedResource.state,displayedResource.zipcode];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error)
         {
             if ([placemarks count] > 0)
             {
                 MKCoordinateRegion region;
                 MKCoordinateSpan span;
                 span.latitudeDelta=DEFAULT_MAP_LATITUDE_DELTA_IN_DEGREES;
                 span.longitudeDelta=DEFAULT_MAP_LONGITUDE_DELTA_IN_DEGREES;
                 
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 CLLocation *location = placemark.location;
                 CLLocationCoordinate2D coordinate = location.coordinate;
                 
                 region.span=span;
                 region.center=coordinate;
                 
                 
                 /*  UIAlertView *alert;
                  alert = [[UIAlertView alloc] initWithTitle:@"Message" message:[NSString stringWithFormat:@"%f", *latitude]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                  
                  [alert show];
                  [alert release];
                  */
                 [mapView setRegion:region animated:YES];
                 
                 CPMapAnnotation *annotation = [[CPMapAnnotation alloc] initWithCoordinate:coordinate andTitle:[displayedResource name] andResourceId:[displayedResource resourceId]];
                 [mapView addAnnotation:annotation];
                 [mapView selectAnnotation:annotation animated:YES];
                 [annotation release];
                 
             }
         }];
    }
    
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

- (IBAction) directions:(id)sender {
    if([locationManager isLocationEnabled]) {
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didGetLocation:) name:LocationManagerFoundLocationNotification object: locationManager];
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didFailToGetLocation:) name:LocationManagerFindLocationFailedNotification object: locationManager];
        [locationManager startFindingCurrentLocation];
    } else {
        NSString *versionNum = [[UIDevice currentDevice] systemVersion];
        NSString *nativeMapScheme = @"maps.apple.com";
        if ([versionNum compare:@"6.0" options:NSNumericSearch] == NSOrderedAscending) {
            nativeMapScheme = @"maps.google.com";
        }
        NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@", displayedResource.address1,displayedResource.city,displayedResource.state,displayedResource.zipcode];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error)
         {
             if ([placemarks count] > 0)
             {
                 
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 CLLocation *location = placemark.location;
                 CLLocationCoordinate2D coordinate = location.coordinate;
                 
                 //region.span=span;
                 //region.center=coordinate;
                 
                 NSString *url = [NSString stringWithFormat:@"http://%@/maps?daddr=%f,%f", nativeMapScheme, coordinate.latitude, coordinate.longitude];
                 
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
                 
                 /*  UIAlertView *alert;
                  alert = [[UIAlertView alloc] initWithTitle:@"Message" message:[NSString stringWithFormat:@"%f", *latitude]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                  
                  [alert show];
                  [alert release];
                  */
                 
             }
         }];
    }
}

// Callbacks for location notifications
- (void) didGetLocation: (NSNotification*) notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LocationManagerFindLocationFailedNotification object:locationManager];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LocationManagerFoundLocationNotification object:locationManager];
    //CLLocation* location = [[notification userInfo] objectForKey:kLocationManagerCurrentLocation];
    
    NSString *versionNum = [[UIDevice currentDevice] systemVersion];
    NSString *nativeMapScheme = @"maps.apple.com";
    if ([versionNum compare:@"6.0" options:NSNumericSearch] == NSOrderedAscending) {
        nativeMapScheme = @"maps.google.com";
    }
    
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@", displayedResource.address1,displayedResource.city,displayedResource.state,displayedResource.zipcode];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error)
     {
         if ([placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             CLLocation *location = placemark.location;
             CLLocationCoordinate2D coordinate = location.coordinate;
             
             NSString *url = [NSString stringWithFormat:@"http://%@/maps?daddr=%f,%f", nativeMapScheme, coordinate.latitude, coordinate.longitude];
             
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
             
         }
     }];
}

- (void) didFailToGetLocation: (NSNotification*) notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LocationManagerFindLocationFailedNotification object:locationManager];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LocationManagerFoundLocationNotification object:locationManager];
    
    NSString *versionNum = [[UIDevice currentDevice] systemVersion];
    NSString *nativeMapScheme = @"maps.apple.com";
    if ([versionNum compare:@"6.0" options:NSNumericSearch] == NSOrderedAscending) {
        nativeMapScheme = @"maps.google.com";
    }
    
    //NSString *url = [NSString stringWithFormat:@"http://%@/maps?daddr=%f,%f", nativeMapScheme, [displayedResource.latitude doubleValue], [displayedResource.longitude doubleValue]];1
    NSString *url = [NSString stringWithFormat:@"http://%@/maps?daddr=%@,%@,%@,%@", nativeMapScheme, [displayedResource address1], [displayedResource city],[displayedResource state],[displayedResource zipcode]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
}

- (void)dealloc {
    [mapView release];
    [displayedResource release];
    [super dealloc];
}

@end
