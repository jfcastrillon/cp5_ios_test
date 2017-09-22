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
@synthesize websiteAddress;

	
- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	//[super initFromJsonDictionary: dictionary];
	if([super init] == nil) return nil;
	self.description = nullFix([dictionary objectForKey: @"description"]);
	self.email = nullFix([dictionary objectForKey: @"email"]);
	self.name = nullFix([dictionary objectForKey: @"name"]);
	self.phone = nullFix([dictionary objectForKey: @"phone"]);
	self.title = nullFix([dictionary objectForKey: @"title"]);
	self.websiteAddress = nullFix([dictionary objectForKey: @"websiteAddress"]);
    
	return self;
}

- (void) dealloc {
	self.description = nil;
	self.email = nil;
	self.name = nil;
	self.phone = nil;
	self.title = nil;
    self.websiteAddress = nil;
	
	[super dealloc];
}

@end
