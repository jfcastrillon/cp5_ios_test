//
//  CPMProviderTelephone.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/21/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMProviderTelephone.h"
#import "Util.h"

@implementation CPMProviderTelephone

@synthesize telephoneId, name, areaCode, prefix, line, extension, fullNumber;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	if([super init] == nil) return nil;
	self.telephoneId = nullFix([dictionary objectForKey: @"id"]);
	self.name = nullFix([dictionary objectForKey: @"name"]);
	self.areaCode = nullFix([dictionary objectForKey: @"area_code"]);
	self.prefix = nullFix([dictionary objectForKey: @"prefix"]);
	self.line = nullFix([dictionary objectForKey: @"line"]);
	self.extension = nullFix([dictionary objectForKey: @"ext"]);
	self.fullNumber = nullFix([dictionary objectForKey:@"number"]);
	
	return self;
}

- (void) dealloc {
	self.telephoneId = nil;
	self.name = nil;
	self.areaCode = nil;
	self.prefix = nil;
	self.line = nil;
	self.extension = nil;
	self.fullNumber = nil;
	[super dealloc];
}

@end
