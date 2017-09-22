//
//  CPMUnitInfo.m
//  CommunityPointMobile
//
//  Created by Matthew Baker on 5/31/13.
//  Copyright (c) 2013 Bowman Systems, LLC. All rights reserved.
//

#import "CPMUnitInfo.h"
#import "Util.h"

@implementation CPMUnitInfo

@synthesize unitListName, unitListType, totalUnits, availableUnits, usedUnits;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	if([super init] == nil) return nil;
	self.unitListName = nullFix([dictionary objectForKey: @"unitListName"]);
	self.unitListType = nullFix([dictionary objectForKey: @"unitListType"]);
    self.totalUnits = nullFix([dictionary objectForKey: @"totalUnits"]);
    self.availableUnits = nullFix([dictionary objectForKey: @"availableUnits"]);
    self.usedUnits = nullFix([dictionary objectForKey: @"usedUnits"]);
	
	return self;
}

- (void) dealloc {
	self.unitListName = nil;
	self.unitListType = nil;
    self.totalUnits = nil;
    self.availableUnits = nil;
    self.usedUnits = nil;
	[super dealloc];
}

@end
