//
//  CPMResourceContact.m
//  CommunityPointMobile
//
//  Created by Ben Carver on 6/22/17.
//  Copyright 2017 Bowman Systems, LLC. All rights reserved.
//


#import "CPMResourceContact.h"
#import "SettingsHelper.h"
#import "Util.h"

@implementation CPMResourceContact

@synthesize description; 
@synthesize email;
@synthesize name; 
@synthesize phone; 
@synthesize title;

	
- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	[super initFromJsonDictionary: dictionary];
	
	self.description = nullFix([dictionary objectForKey: @"description"]);
	self.email = nullFix([dictionary objectForKey: @"email"]);
	self.name = nullFix([dictionary objectForKey: @"name"]);
	self.phone = nullFix([dictionary objectForKey: @"phone"]);
	self.title = nullFix([dictionary objectForKey: @"title"]);
	
	return self;
}

- (void) dealloc {
	self.description = nil;
	self.email = nil;
	self.name = nil;
	self.phone = nil;
	self.title = nil;
	
	[super dealloc];
}

@end
