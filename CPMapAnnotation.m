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

+ (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate {
	CPMapAnnotation *annotation = [super alloc];
	annotation.coordinate = coordinate;
	return annotation;
}

+ (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *) title {
	CPMapAnnotation *annotation = [super alloc];
	annotation.coordinate = coordinate;
	annotation.title = title;
	return annotation;
}

+ (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *) title andSubtitle:(NSString*) subtitle {
	CPMapAnnotation *annotation = [super alloc];
	annotation.coordinate = coordinate;
	annotation.title = title;
	annotation.subtitle = subtitle;
	return annotation;
}

- (void) dealloc {
	[title release];
	[subtitle release];
	[super dealloc];
}


@end
