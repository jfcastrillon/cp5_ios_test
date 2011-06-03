//
//  CPMResourceArrayParser.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/17/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMSearchResultsParser.h"
#import "CPMResource.h"
#import "CPMSearchResultSet.h"
#import "Util.h"

NSArray* translateResourceArray(NSArray* jsonArray) {
	NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity: [jsonArray count]];
	for(NSDictionary* jsonResource in jsonArray) {
		CPMResource* newResource = [[CPMResource alloc] initFromJsonDictionary:jsonResource];
		[results addObject:newResource];
		[newResource release];
	}
	return results;
}

@implementation CPMSearchResultsParser

- (id) parseData:(NSData*) data {
	id jsonResult = [super parseData: data];
	
	CPMSearchResultSet* result = [[CPMSearchResultSet alloc] init];
	result.offset = nullFix([[jsonResult objectForKey: @"resources"] objectForKey: @"base"]);
	result.count = nullFix([[jsonResult objectForKey: @"resources"] objectForKey: @"range"]);
	result.totalCount = nullFix([[jsonResult objectForKey: @"resources"] objectForKey: @"total"]);
	result.searchHistoryId = nullFix([[jsonResult objectForKey: @"resources"] objectForKey: @"search_history_id"]);
	NSString* refLatStr = nullFix([[jsonResult objectForKey: @"resources"] objectForKey: @"ref_latitude"]);
	NSString* refLonStr = nullFix([[jsonResult objectForKey: @"resources"] objectForKey: @"ref_longitude"]);
	result.refLatitude = (refLatStr == nil) ? nil : [NSNumber numberWithFloat: [refLatStr floatValue]];
	result.refLongitude = (refLonStr == nil) ? nil : [NSNumber numberWithFloat: [refLonStr floatValue]];
	
	NSArray* results = translateResourceArray([[jsonResult objectForKey: @"resources"] objectForKey: @"results"]);
	result.results = results;
	[results release];
	
	return [result autorelease];
}

@end
