//
//  CPMapAnnotation.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/11/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMapAnnotation.h"


@implementation CPMapAnnotation

@synthesize title, subtitle;
@synthesize resourceId;

- (id) initWithCoordinate:(CLLocationCoordinate2D)_coordinate {
	[super init];
	self.coordinate = coordinate;
    
	return self;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)_coordinate andTitle:(NSString *) _title {
	[super init];
	self.coordinate = _coordinate;
	self.title = [_title copy];
	return self;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)_coordinate andTitle:(NSString *) _title andSubtitle:(NSString*) _subtitle {
	[super init];
	self.coordinate = _coordinate;
	self.title = [_title copy];
	self.subtitle = _subtitle;
	return self;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)_coordinate andTitle:(NSString *) _title andResourceId:(NSDecimalNumber *)_resourceId {
	[super init];
	self.coordinate = _coordinate;
	self.title = [_title copy];
	self.resourceId = _resourceId;
	return self;
}

- (CLLocationCoordinate2D) coordinate {
    return coordinate;
}

- (void) setCoordinate:(CLLocationCoordinate2D)_coordinate {
    coordinate = _coordinate;
}

- (void) dealloc {
	[title release];
	[subtitle release];
	[resourceId release];
	[super dealloc];
}


@end
