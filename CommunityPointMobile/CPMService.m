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

- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	if([super init] == nil) return nil;
	self.name = nullFix([dictionary objectForKey: @"name"]);
	self.code = nullFix([dictionary objectForKey: @"code"]);
	
	return self;
}

@end
