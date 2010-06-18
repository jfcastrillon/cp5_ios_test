//
//  XServicesHelper.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "XServicesHelper.h"
#import "XSResourceSearchOperation.h"
#import "XSResourceDetailsOperation.h"
#import "CPMResource.h"
#import "CPMSearchResultSet.h"
#import "CPMResourceDetail.h"

@implementation XServicesHelper

@synthesize searchResults, currentResource;

- (id) init {
	if([super init] == nil) return nil;
	operationQueue = [[NSOperationQueue alloc] init];
	if(operationQueue == nil) return nil;
	
	searchResults = [[NSMutableArray alloc] init];
	
	return self;
}

// XServices simplified methods
- (void)searchResourcesWithQuery:(NSString*)query {
	XSResourceSearchOperation *op = [[XSResourceSearchOperation alloc] initWithQuery: query andMaxCount: 50];
	op.delegate = self;
	[operationQueue addOperation: op];
	[op release];
}

- (void)loadMoreResults {
	// TODO assert lastSearchResults != nil
	XSResourceSearchOperation *op = [[XSResourceSearchOperation alloc] initWithQuery: lastQuery andMaxCount:50 andOffset:[[lastSearchResultSet offset] intValue] + [[lastSearchResultSet count] intValue] andSearchHistoryId:[[lastSearchResultSet searchHistoryId] intValue]];
	op.delegate = self;
	[operationQueue addOperation: op];
	[op release];
}

- (void)retrieveProviderCount {
	//[self createConnectionForMethod:@"accounts.get_info" withParameters:params];
}

- (void) retrieveResourceDetails:(NSDecimalNumber*)resourceId{
	//[self createConnectionForMethod:@"resources.pull" withParameters:params];
}

- (void)loadResourceDetails: (NSDecimalNumber*) resourceId{
	XSResourceDetailsOperation *op = [[XSResourceDetailsOperation alloc] initWithResourceId: [resourceId intValue]];
	op.delegate = self;
	[operationQueue addOperation: op];
	[op release];
}

- (void) cancelAllOperations {
	[operationQueue cancelAllOperations];
}

- (void) operationDidComplete: (XSResponse*) response {
	if([[response tag] isEqualToString: @"resources.search"]) {
		if ([[[response result] offset] intValue] == 0)
			[searchResults removeAllObjects];
		[searchResults addObjectsFromArray: [[response result] results]];
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName: @"SearchResultsReceived" object: self]];
	} else if([[response tag] isEqualToString: @"resources.pull"]) {
		currentResource = [response result];
		[currentResource retain];
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName: @"ResourceDetailsReceived" object: self]];
	}
}

- (void) dealloc {
	[operationQueue release], operationQueue = nil;
	[searchResults release], searchResults = nil;
	[lastSearchResultSet release], lastSearchResultSet = nil;
	[super dealloc];
}

@end
