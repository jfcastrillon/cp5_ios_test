//
//  CPMResource.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/4/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMResource.h"
#import "Util.h"

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
@synthesize distanceToRef;
@synthesize accessibilityFlag;
@synthesize isShelter;
@synthesize callCenterFlag;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	if([super init] == nil) return nil;
	self.resourceId = nullFix([dictionary objectForKey: @"id"]);
	self.providerId = nullFix([dictionary objectForKey: @"provider_id"]);
	self.name = nullFix([dictionary objectForKey:@"name"]);
	self.address1 = nullFix([dictionary objectForKey:@"address1"]);
	self.address2 = nullFix([dictionary objectForKey:@"address2"]);
	self.city = nullFix([dictionary objectForKey:@"city"]);
	self.state = nullFix([dictionary objectForKey:@"state"]);
    
	// XServices returns ZIP as an integer for some reason
	NSObject* tmpZip = nullFix([dictionary objectForKey:@"zipcode"]);
	if(tmpZip != nil) {
		if([tmpZip isKindOfClass: [NSDecimalNumber class]]) {
			self.zipcode = [(NSDecimalNumber*)tmpZip stringValue];
		} else {
			self.zipcode = (NSString*) tmpZip;
		}
	}
	
	self.url = nullFix([dictionary objectForKey:@"url"]);
	self.phone = nullFix([dictionary objectForKey:@"phone"]);
	self.latitude = nullFix([dictionary objectForKey:@"latitude"]);
	self.longitude = nullFix([dictionary objectForKey:@"longitude"]);
	self.distanceToRef = nullFix([dictionary objectForKey:@"distance"]);
	self.accessibilityFlag = nullFix([dictionary objectForKey:@"handicap_access"]);
	self.isShelter = nullFix([dictionary objectForKey:@"is_shelter"]);
	self.callCenterFlag = nullFix([dictionary objectForKey:@"is_callcenter"]);
	
	return self;
}

- (void) dealloc {
	self.resourceId = nil;
	self.providerId = nil;
	self.name = nil;
	self.address1 = nil;
	self.address2 = nil;
	self.city = nil;
	self.state = nil;
	self.zipcode = nil;
	self.url = nil;
	self.phone = nil;
	self.latitude = nil;
	self.longitude = nil;
	self.distanceToRef = nil;
	[super dealloc];
}

- (NSDictionary*) dictionaryValue {
	NSMutableDictionary * value;
	
	// allocate an NSMutableDictionary to hold our Resource
    value = [[NSMutableDictionary alloc] init];

	[value setObject:resourceId forKey:@"id"];
    [value setObject:providerId forKey:@"provider_id"];
    [value setObject:name forKey:@"name"];
	
	if (address1)
		[value setObject:address1 forKey:@"address1"];
	if (address2)
		[value setObject:address2 forKey:@"address2"];
	if (city)
		[value setObject:city forKey:@"city"];
	if (state)
		[value setObject:state forKey:@"state"];
	if (zipcode)
		[value setObject:zipcode forKey:@"zipcode"];
	if (url)
		[value setObject:url forKey:@"url"];
	if (phone)
		[value setObject:phone forKey:@"phone"];
	if (latitude)
		[value setObject:latitude forKey:@"latitude"];
	if (longitude)
		[value setObject:longitude forKey:@"longitude"];
	if (accessibilityFlag)
		[value setObject:accessibilityFlag forKey:@"handicap_access"];
	if (isShelter)
		[value setObject:isShelter forKey:@"is_shelter"];
	if (callCenterFlag)
		[value setObject:callCenterFlag forKey:@"is_callcenter"];

	[value autorelease];

	return value;
}

- (NSString*) addressString {
	NSMutableString *addressLine = [[NSMutableString alloc] init];
	NSMutableArray *addressParts = [[NSMutableArray alloc] init];
	
	if (address1)
        [addressParts addObject: address1];
	if (city)
		[addressParts addObject: city];
	if (state)
		[addressParts addObject: state];
	
	for (int i = 0; i < [addressParts count]; i++) {
		NSString* part = [addressParts objectAtIndex:i];
		part = [part stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([part length] > 0) {
            [addressLine appendString: part];
            if (i + 1 < [addressParts count]) {
                [addressLine appendString: @", "];
            }
        }
	}
	
	[addressLine autorelease];
	[addressParts release];
	return addressLine;
}

@end
