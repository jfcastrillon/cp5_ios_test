//
//  CPMResource.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/4/10.
//  Copyright 2010 Louisiana State University-Shreveport. All rights reserved.
//

#import "CPMResource.h"


@implementation CPMResource

@synthesize resourceId;
@synthesize providerId;
@synthesize name;
@synthesize address1;
@synthesize address2;
@synthesize city;
@synthesize state;
@synthesize zipcode;
@synthesize url;
@synthesize phone;
@synthesize latitude;
@synthesize longitude;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	self.resourceId = [[dictionary objectForKey: @"id"] intValue];
	self.providerId = [[dictionary objectForKey: @"provider_id"] intValue];
	self.name = [dictionary objectForKey:@"name"];
	self.address1 = [dictionary objectForKey:@"address1"];
	self.address2 = [dictionary objectForKey:@"address2"];
	self.city = [dictionary objectForKey:@"city"];
	self.state = [dictionary objectForKey:@"state"];
	self.zipcode = [dictionary objectForKey:@"zipcode"];
	self.url = [dictionary objectForKey:@"url"];
	self.phone = [dictionary objectForKey:@"phone"];
	self.latitude = [dictionary objectForKey:@"latitude"];
	self.longitude = [dictionary objectForKey:@"longitude"];
	
	return self;
}

@end
