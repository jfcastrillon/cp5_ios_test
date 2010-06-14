//
//  CPMResource.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/4/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
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

id nullFix(id value) {
	if((NSNull*)value == [NSNull null])
		return nil;
	//if([value isKindOfClass:[NSString class]] && [value length] == 0)
	//	return nil;
	else
		return value;

}

- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	self.resourceId = nullFix([dictionary objectForKey: @"id"]);
	self.providerId = nullFix([dictionary objectForKey: @"provider_id"]);
	self.name = nullFix([dictionary objectForKey:@"name"]);
	self.address1 = nullFix([dictionary objectForKey:@"address1"]);
	self.address2 = nullFix([dictionary objectForKey:@"address2"]);
	self.city = nullFix([dictionary objectForKey:@"city"]);
	self.state = nullFix([dictionary objectForKey:@"state"]);
	self.zipcode = nullFix([dictionary objectForKey:@"zipcode"]);
	self.url = nullFix([dictionary objectForKey:@"url"]);
	self.phone = nullFix([dictionary objectForKey:@"phone"]);
	self.latitude = nullFix([dictionary objectForKey:@"latitude"]);
	self.longitude = nullFix([dictionary objectForKey:@"longitude"]);
	
	return self;
}

@end
