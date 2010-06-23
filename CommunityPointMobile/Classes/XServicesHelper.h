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
#import "NetworkManager.h"

@interface XServicesHelper : NSObject {
	NSOperationQueue *operationQueue;
	
	NSMutableArray *searchResults;
	NSMutableArray *favorites;
	CPMSearchResultSet *lastSearchResultSet;
	NSString *lastQuery;
	
	NetworkManager *networkManager;
	
	CPMResourceDetail *currentResource;
}

@property (nonatomic, readonly) NSArray *searchResults;
@property (nonatomic, readonly) NSMutableArray *favorites;
@property (nonatomic, readonly) CPMResourceDetail *currentResource;
@property (nonatomic, copy) NSString *lastQuery;
@property (nonatomic, retain) CPMSearchResultSet *lastSearchResultSet;


- (id) init;

// XServices simplified methods
- (void)searchResourcesWithQuery:(NSString*)query;
- (void)loadMoreResults;

- (void)retrieveProviderCount;

- (void)loadResourceDetails: (NSDecimalNumber*) resourceId;

- (void) operationDidComplete: (XSResponse*) response;
- (void) operationDidFailWithError: (NSError*) error;

- (void) cancelAllOperations;

- (void) addResourceToFavorites: (CPMResource*) resource;
- (BOOL) isResourceInFavorites:(CPMResource*) resource;
- (void) updateFavoriteFromResource:(CPMResource*) resource;
- (void) removeResourceFromFavorites:(CPMResource*) resource;
- (void) removeFavoriteAtIndex:(NSUInteger) index;
- (void) persistFavorites;

+ (XServicesHelper*) sharedInstance;

@end
