//
//  CPMService.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/21/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMService.h"
#import "Util.h"

@implementation CPMService

@synthesize name, code;
@synthesize serviceDetails;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	if([super init] == nil) return nil;
	self.name = nullFix([dictionary objectForKey: @"name"]);
	self.code = nullFix([dictionary objectForKey: @"code"]);
	
	// extract service details
	NSDictionary* detailsDict = nullFix([dictionary objectForKey: @"service_details"]);
        if(detailsDict != nil) {
            CPMServiceDetail *tempDetails = [[CPMServiceDetail alloc] initFromJsonDictionary: detailsDict];
            self.serviceDetails = tempDetails;
        }
	
	return self;
}

- (void) dealloc {
	self.name = nil;
	self.code = nil;
	[super dealloc];
}

@end
