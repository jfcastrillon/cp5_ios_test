//
//  CPMapAnnotation.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/11/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CPMapAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	NSDecimalNumber	*resourceId;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSDecimalNumber *resourceId;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *) title;
- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *) title andSubtitle:(NSString*) subtitle;
- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *) title andResourceId:(NSDecimalNumber *)resourceId;


@end
