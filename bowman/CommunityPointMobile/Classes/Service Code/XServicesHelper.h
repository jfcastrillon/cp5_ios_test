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
#import "SettingsHelper.h"
#import "XSQueryParamKeys.h"
#import "CPMSettings.h"

@interface XServicesHelper : NSObject {
	NSOperationQueue *operationQueue;
	
	NSMutableArray *searchResults;
	NSMutableArray *favorites;
	NSArray *commonSearches;
	CPMSearchResultSet *lastSearchResultSet;
	NSString *lastQuery;
	NSDictionary* lastQueryParams;

	NetworkManager *networkManager;
	
	CPMResourceDetail *currentResource;
	BOOL isSearching;
}

@property (nonatomic, readonly) NSArray *searchResults;
@property (nonatomic, readonly) NSArray *commonSearches;
@property (nonatomic, readonly) NSMutableArray *favorites;
@property (nonatomic, readonly) CPMResourceDetail *currentResource;
@property (nonatomic, copy) NSString *lastQuery;
@property (nonatomic, copy) NSDictionary *lastQueryParams;
@property (nonatomic, retain) CPMSearchResultSet *lastSearchResultSet;


- (id) init;
- (BOOL) isSearching;

// XServices simplified methods
- (void)searchResourcesWithQueryParams: (NSDictionary*) params;
- (void)searchResourcesWithQuery:(NSString*)query;
- (void)searchResourcesWithQuery:(NSString*)query forLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude;
- (void)loadMoreResults;

- (void)loadCommonSearches;

- (void)loadResourceDetails: (NSDecimalNumber*) resourceId;
//- (void)loadResourceDetails: (NSDecimalNumber*) resourceId forSearchHistoryId: (NSDecimalNumber*)searchId;

- (void) operationDidComplete: (XSResponse*) response;
- (void) operationDidFailWithError: (NSDictionary*) error;

- (void) loadXsSettings;

- (void) cancelAllOperations;

- (void) addResourceToFavorites: (CPMResource*) resource;
- (BOOL) isResourceInFavorites:(CPMResource*) resource;
- (void) updateFavoriteFromResource:(CPMResource*) resource;
- (void) removeResourceFromFavorites:(CPMResource*) resource;
- (void) removeFavoriteAtIndex:(NSUInteger) index;
- (void) persistFavorites;

+ (XServicesHelper*) sharedInstance;

@end
