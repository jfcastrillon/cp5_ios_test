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
	result.offset = [[jsonResult objectForKey: @"resources"] objectForKey: @"base"];
	result.count = [[jsonResult objectForKey: @"resources"] objectForKey: @"range"];
	result.totalCount = [[jsonResult objectForKey: @"resources"] objectForKey: @"total"];
	result.searchHistoryId = [[jsonResult objectForKey: @"resources"] objectForKey: @"search_history_id"];
	
	result.results = translateResourceArray([[jsonResult objectForKey: @"resources"] objectForKey: @"results"]);
	
	//[jsonResult release];
	
	return result;
}

@end
