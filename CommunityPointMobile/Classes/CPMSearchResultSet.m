//
//  CPMSearchResultSet.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/17/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMSearchResultSet.h"


@implementation CPMSearchResultSet

@synthesize searchHistoryId;
@synthesize offset;
@synthesize count;
@synthesize totalCount;
@synthesize refLatitude, refLongitude;
@synthesize results;

- (void) dealloc {
	self.searchHistoryId = nil;
	self.offset = nil;
	self.count = nil;
	self.totalCount = nil;
	self.refLongitude = nil;
	self.refLatitude = nil;
	self.results = nil;
	[super dealloc];
}

@end
