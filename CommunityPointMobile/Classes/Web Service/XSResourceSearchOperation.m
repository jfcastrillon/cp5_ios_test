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
	// Setup query parameters
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setValue: [NSDecimalNumber numberWithUnsignedInt: searchHistoryId] forKey:kXSQuerySearchHistoryId];
	[params setValue: [NSDecimalNumber numberWithUnsignedInt: maxCount] forKey:kXSQueryMaxCount];	
	[params setValue: [NSDecimalNumber numberWithUnsignedInt: offset] forKey:kXSQueryOffset];	
	[params setValue: query forKey:kXSQueryNatural];
	
	[self initWithQueryParams:params];
	
	[params release];
	
	return self;
}

- (NSString*) buildQueryStringFromAll:(NSString*)all any:(NSString*)any none:(NSString*)none {
	NSMutableString* fullQuery = [[NSMutableString alloc] init];
	
	if(all != nil) {
		NSArray* parts = [all componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
		
		for (NSString* part in parts) {
			[fullQuery appendString:@"+"];
			[fullQuery appendString:part];
			[fullQuery appendString:@" "];
		}
	}
	
	if(none != nil) {
		NSArray* parts = [none componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
		
		for (NSString* part in parts) {
			[fullQuery appendString:@"-"];
			[fullQuery appendString:part];
			[fullQuery appendString:@" "];
		}
	}
	
	if(any != nil) {
		[fullQuery appendString: any];
	}
	return fullQuery;
}

- (id) initWithQueryParams: (NSDictionary*) queryParams {
	if([super init] == nil) return nil;
	
#define AssertParamSet(key) NSAssert([queryParams objectForKey:(key)] != nil, @"Required parameter key not set.") 
	
	AssertParamSet(kXSQuerySearchHistoryId);
	AssertParamSet(kXSQueryMaxCount);
	AssertParamSet(kXSQueryOffset);
	
#undef AssertParamSet
	
	// Setup method call paramters
	NSMutableDictionary* params = [queryParams mutableCopy];  // Make a copy
	
	NSUInteger maxCount = [[params objectForKey:kXSQueryMaxCount] unsignedIntValue];
	NSUInteger offset = [[params objectForKey:kXSQueryOffset] unsignedIntValue];

	// Convert to page number for XS
	[params setValue: [[NSDecimalNumber numberWithUnsignedInt: offset == 0 ? 1 : offset/maxCount + 1] stringValue] forKey:@"page"];
	
	// Combine terms for advanced search if supplied
	NSString* natural = [params objectForKey:kXSQueryNatural];
	NSString* any = [params objectForKey:kXSQueryKeywordsAny];
	NSString* none = [params objectForKey:kXSQueryKeywordsNone];
	NSString* all = [params objectForKey:kXSQueryKeywordsAll];
	NSString* query = natural ? natural : @"";
	if (any || none || all) {
		NSAssert(natural == nil, @"Cannot provide a natural language query when using advanced search keyword fields");
		query = [self buildQueryStringFromAll:all any:any none:none];
	}
	
	// Constructed query is a natural query
	[params setObject:query forKey:kXSQueryNatural];
	
	// Parser for the response data
	id parser = [[CPMSearchResultsParser alloc] init];
	
	// Let the base class handle the rest
	[super initWithAction: @"resources.search" andParameters: params andParser: parser];
	
	[params release];
	[parser release];
	
	return self;
}

- (id) initLocationBasedRequestWithQuery:(NSString *)query forLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude andMaxCount:(NSUInteger)maxCount {
	return [self initLocationBasedRequestWithQuery:query forLatitude:latitude andLongitude:longitude andMaxCount:maxCount andOffset:0 andSearchHistoryId: -1];
}

- (id) initLocationBasedRequestWithQuery:(NSString *)query forLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude andMaxCount:(NSUInteger)maxCount andOffset: (NSUInteger) offset andSearchHistoryId: (NSUInteger) searchHistoryId {
	// Setup query parameters
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setValue: [NSDecimalNumber numberWithUnsignedInt: searchHistoryId] forKey:kXSQuerySearchHistoryId];
	[params setValue: [NSDecimalNumber numberWithUnsignedInt: maxCount] forKey:kXSQueryMaxCount];
	[params setValue: [NSDecimalNumber numberWithUnsignedInt: offset] forKey:kXSQueryOffset];

	[params setValue: latitude forKey:kXSQueryReferenceLatitude];
	[params setValue: longitude forKey:kXSQueryReferenceLongitude];
	[params setValue: @"true" forKey:@"sort_by_distance"];
	[params setValue: query forKey:kXSQueryNatural];
	
	[self initWithQueryParams: params];	
	
	[params release];

	return self;
}


@end
