//
//  CPMapAnnotation.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/11/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMapAnnotation.h"


@implementation CPMapAnnotation

@synthesize coordinate = _coordinate, title, subtitle;
@synthesize resourceId;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate {
	[super init];
	self.coordinate = coordinate;
	return self;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *) title {
	[super init];
	self.coordinate = coordinate;
	self.title = title;
	return self;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *) title andSubtitle:(NSString*) subtitle {
	[super init];
	self.coordinate = coordinate;
	self.title = title;
	self.subtitle = subtitle;
	return self;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *) title andResourceId:(NSDecimalNumber *)resourceId {
	[super init];
	self.coordinate = coordinate;
	self.title = title;
	self.resourceId = resourceId;
	return self;
}

- (void) dealloc {
	[title release];
	[subtitle release];
	[resourceId release];
	[super dealloc];
}


@end
