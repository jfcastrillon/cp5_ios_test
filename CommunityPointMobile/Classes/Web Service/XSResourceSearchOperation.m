//
//  XSResourceSearchOperation.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/17/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "XSResourceSearchOperation.h"
#import "CPMSearchResultsParser.h"


@implementation XSResourceSearchOperation

- (id) initWithQuery: (NSString*) query andMaxCount: (NSUInteger) maxCount {
	return [self initWithQuery:query andMaxCount:maxCount andOffset:0 andSearchHistoryId:-1];
}

- (id) initWithQuery: (NSString*) query andMaxCount: (NSUInteger) maxCount andOffset: (NSUInteger) offset andSearchHistoryId: (NSUInteger) searchHistoryId {
	if([super init] == nil) return nil;
	
	_query = [query retain];
	
	// Setup method call paramters
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setValue: [[NSDecimalNumber numberWithUnsignedInt: searchHistoryId] stringValue] forKey:@"search_history_id"];
	[params setValue: [[NSDecimalNumber numberWithUnsignedInt: maxCount] stringValue] forKey:@"limit"];	
	[params setValue: query forKey:@"query"];
	
	// Parser for the response data
	id parser = [[CPMSearchResultsParser alloc] init];
	
	// Let the base class handle the rest
	[super initWithAction: @"resources.search" andParameters: params andParser: parser];
	
	[params release];
	[parser release];
	
	return self;
}

@end
