//
//  CPMSettings.m
//  CommunityPointMobile
//
//  Created by Matthew Baker on 5/22/13.
//  Copyright (c) 2013 Bowman Systems, LLC. All rights reserved.
//

#import "CPMSettings.h"

@implementation CPMSettings

@synthesize settings;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	if([super init] == nil) return nil;
	self.settings = [dictionary copy];
	
	return self;
}

- (void) dealloc {
	self.settings = nil;
	[super dealloc];
}

@end
