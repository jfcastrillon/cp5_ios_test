//
//  CPMProviderAddress.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/18/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMProviderAddress.h"
#import "Util.h"

@implementation CPMProviderAddress

@synthesize addressId, type, active, description, line1, line2, city, province, postalcode, county, country, landmarks;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	if([super init] == nil) return nil;
	self.addressId = nullFix([dictionary objectForKey: @"id"]);
	
	NSString *typeString = nullFix([dictionary objectForKey: @"provider_id"]);
	if(typeString != nil && [typeString isEqualToString: @"SP5_PHYSICAL_ADDRESS"]) {
		self.type = CPMPhysicalAddress;
	} else {
		self.type = CPMMailingAddress;
	}
	
	self.active = nullFix([dictionary objectForKey:@"active"]);
	self.line1 = nullFix([dictionary objectForKey:@"1"]);
	self.line2 = nullFix([dictionary objectForKey:@"2"]);
	self.city = nullFix([dictionary objectForKey:@"city"]);
	self.province = nullFix([dictionary objectForKey:@"province"]);
	self.county = nullFix([dictionary objectForKey:@"county"]);
	self.country = nullFix([dictionary objectForKey:@"country"]);
	self.postalcode = nullFix([dictionary objectForKey:@"postalcode"]);
	self.landmarks = nullFix([dictionary objectForKey:@"landmarks"]);
	
	return self;
}

- (NSString*) multilineStringValue {
	NSMutableString *addressLine = [[NSMutableString alloc] init];
	NSMutableArray *addressParts = [[NSMutableArray alloc] init];
	
	if(line1 != nil &&
	   [line1 length] > 0)
		[addressLine appendFormat: @"%@\n", line1];
	if(line2 != nil &&
	   [line2 length] > 0)
		[addressLine appendFormat: @"%@\n", line2];
	
	if(city != nil)
		[addressParts addObject: city];
	if(province != nil)	
		[addressParts addObject: province];
	if(postalcode != nil)	
		[addressParts addObject: postalcode];
	
	for(int i = 0; i < [addressParts count]; i++) {
		NSString* part = [addressParts objectAtIndex:i];
		if(part != nil) {
			part = [part stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if([part length] > 0) {
				[addressLine appendString: part];
				if(i+1 < [addressParts count])
					[addressLine appendString: @", "];
			}
		}
	}
	
	[addressLine autorelease];
	[addressParts release];
	return addressLine;
}

- (NSString*) stringValue {
	
	NSMutableString *addressLine = [[NSMutableString alloc] init];
	NSMutableArray *addressParts = [[NSMutableArray alloc] init];
	
	if(line1 != nil &&
	   [line1 length] > 0)
		[addressLine appendFormat: @"%@\n", line1];
	if(city != nil)
		[addressParts addObject: city];
	if(province != nil)	
		[addressParts addObject: province];
	
	for(int i = 0; i < [addressParts count]; i++) {
		NSString* part = [addressParts objectAtIndex:i];
		if(part != nil) {
			part = [part stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if([part length] > 0) {
				[addressLine appendString: part];
				if(i+1 < [addressParts count])
					[addressLine appendString: @", "];
			}
		}
	}
	
	[addressLine autorelease];
	[addressParts release];
	return addressLine;
}

@end
