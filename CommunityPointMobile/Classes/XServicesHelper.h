//
//  XServicesHelper.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSResponse.h"
#import "CPMSearchResultSet.h"
#import "CPMResourceDetail.h"

@interface XServicesHelper : NSObject {
	NSOperationQueue *operationQueue;
	
	NSMutableArray *searchResults;
	CPMSearchResultSet *lastSearchResultSet;
	NSString *lastQuery;
	
	CPMResourceDetail *currentResource;
}

@property (nonatomic, readonly) NSArray *searchResults;
@property (nonatomic, readonly) CPMResourceDetail *currentResource;

- (id) init;

// XServices simplified methods
- (void)searchResourcesWithQuery:(NSString*)query;
- (void)loadMoreResults;

- (void)retrieveProviderCount;

- (void)loadResourceDetails: (NSDecimalNumber*) resourceId;

- (void) operationDidComplete: (XSResponse*) response;

- (void) cancelAllOperations;

+ (XServicesHelper*) sharedInstance;

@end
