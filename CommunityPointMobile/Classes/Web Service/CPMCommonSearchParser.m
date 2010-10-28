//
//  CPMCommonSearchParser.m
//  CommunityPointMobile
//
//  Created by John Cannon on 10/21/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMCommonSearchParser.h"
#import "CPMCommonSearch.h"


NSArray* translateCommonSearchArray(NSArray* jsonArray) {
	NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity: [jsonArray count]];
	for(NSDictionary* jsonResource in jsonArray) {
		CPMCommonSearch* newSearch = [[CPMCommonSearch alloc] initFromJsonDictionary:jsonResource];
		[results addObject:newSearch];
		[newSearch release];
	}
	return results;
}

@implementation CPMCommonSearchParser

- (id) parseData:(NSData*) data {
	id jsonResult = [super parseData: data];
	
	NSArray* results = translateCommonSearchArray([[jsonResult objectForKey:@"searches"] allValues]);
	
	NSSortDescriptor *sortDescriptor;
	sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"sort"
												  ascending:YES] autorelease];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	NSArray *sortedArray;
	sortedArray = [results sortedArrayUsingDescriptors:sortDescriptors];
	[results release];
	
	return sortedArray;
}
@end
