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
#import "XSCommonSearchListOperation.h"
#import "CPMResource.h"

#define RESULT_PAGE_SIZE 10

@implementation XServicesHelper

@synthesize searchResults, currentResource, favorites, lastQuery, lastQueryParams, lastSearchResultSet, commonSearches;

- (id) init {
	if([super init] == nil) return nil;
	
	// Set up operation queue
	operationQueue = [[NSOperationQueue alloc] init];
	if(operationQueue == nil) return nil;
	
	networkManager = [NetworkManager sharedInstance];
	
	searchResults = [[NSMutableArray alloc] init];

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsPath = [paths objectAtIndex:0]; 
	
	// <Application Home>/Documents/Favorites.plist 
	NSString *path = [documentsPath stringByAppendingPathComponent:@"Favorites.plist"];
	NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
	
	// If the tmpArray is nil, that means that this is the first time the
	// application has launched since install. In that case we need to copy
	// the template Favorites.plist from the Resources directory into the Documents
	// directory.
	if (!tmpArray) {
		NSString *installpath = [[NSBundle mainBundle] pathForResource:@"Favorites" ofType:@"plist"];
		NSMutableArray *installArray = [[NSMutableArray alloc] initWithContentsOfFile:installpath];
		[favorites release];
		favorites = installArray;
		[favorites writeToFile:path atomically:YES];
	} else {
		[favorites release];
		favorites = tmpArray;
	}
	
	return self;
}

- (BOOL) isSearching {
	return isSearching;	
}

- (void) searchResourcesWithQueryParams: (NSDictionary*) params{
	isSearching = YES;
	NSMutableDictionary* mutableParams = [params mutableCopy];
	[mutableParams setObject:[NSDecimalNumber numberWithInt:RESULT_PAGE_SIZE] forKey:kXSQueryMaxCount];
	[mutableParams setObject:[NSDecimalNumber numberWithInt:0] forKey:kXSQueryOffset];
	[mutableParams setObject:[NSDecimalNumber numberWithInt:-1] forKey:kXSQuerySearchHistoryId];
	
	self.lastQueryParams = mutableParams;
	
	XSResourceSearchOperation *op = [[XSResourceSearchOperation alloc] initWithQueryParams:mutableParams];
	op.delegate = self;
	[operationQueue addOperation: op];
	[op release];
	[mutableParams release];
}

// XServices simplified methods
- (void)searchResourcesWithQuery:(NSString*)query {
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:query forKey:kXSQueryNatural];
	[self searchResourcesWithQueryParams: params];
	[params release];
}

- (void)searchResourcesWithQuery:(NSString*)query forLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude {
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:query forKey:kXSQueryNatural];
	[params setObject:latitude forKey:kXSQueryReferenceLatitude];
	[params setObject:longitude forKey:kXSQueryReferenceLongitude];
	[params setValue: @"true" forKey:kXSSortByDistance];
	[self searchResourcesWithQueryParams:params];
	[params release];
}

- (void)loadMoreResults {
	// TODO assert lastSearchResults != nil
	isSearching = YES;
	
	NSMutableDictionary* params = [lastQueryParams mutableCopy];
	NSUInteger count = RESULT_PAGE_SIZE;
	NSUInteger offset = [[lastSearchResultSet offset] intValue] + RESULT_PAGE_SIZE;
	[params setObject:[NSDecimalNumber numberWithUnsignedInt:count] forKey:kXSQueryMaxCount];
	[params setObject:[NSDecimalNumber numberWithUnsignedInt:offset] forKey:kXSQueryOffset];
	[params setObject:[lastSearchResultSet searchHistoryId] forKey:kXSQuerySearchHistoryId];
	
	XSResourceSearchOperation *op = [[XSResourceSearchOperation alloc] initWithQueryParams:params];
	[params release];
	op.delegate = self;
	[operationQueue addOperation: op];
	[op release];
}

- (void)loadResourceDetails: (NSDecimalNumber*) resourceId{
    XSResourceDetailsOperation *op = [[XSResourceDetailsOperation alloc] initWithResourceId: [resourceId intValue]];
    op.delegate = self;
    [operationQueue addOperation: op];
    [op release];
}

- (void) loadCommonSearches {
	XSCommonSearchListOperation *op  = [[XSCommonSearchListOperation alloc] init];
	op.delegate = self;
	[operationQueue addOperation:op];
	[op release];
}

- (void) cancelAllOperations {
	isSearching = NO;
	[operationQueue cancelAllOperations];
}

- (BOOL) isResourceInFavorites:(CPMResource*) resource {
	for(NSDictionary* favorite in favorites) {
		if([[favorite objectForKey:@"resourceId"] isEqual: [resource resourceId]])
			return YES;
	}
	return NO;
}

- (void) addResourceToFavorites:(CPMResource*) resource{
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
	[dictionary setObject: [resource resourceId] forKey: @"resourceId"];
	[dictionary setObject: [resource name] forKey: @"name"];
	[dictionary setObject: [resource addressString] forKey: @"address"];
	[dictionary setObject: [resource accessibilityFlag] forKey: @"accessibilityFlag"];
	[dictionary setObject: [resource isShelter] forKey:@"shelterFlag"];
	[favorites addObject: dictionary];
	[dictionary release];
}


// Updates the cached information about the favorite (i.e., when it is reloaded from the server)
- (void) updateFavoriteFromResource:(CPMResource*) resource {
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
	[dictionary setObject: [resource resourceId] forKey: @"resourceId"];
	[dictionary setObject: [resource name] forKey: @"name"];
	[dictionary setObject: [resource addressString] forKey: @"address"];
	[dictionary setObject: [resource accessibilityFlag] forKey: @"accessibilityFlag"];
	[dictionary setObject: [resource isShelter] forKey:@"shelterFlag"];
	
	for(NSUInteger i = 0; i < [favorites count]; i++){
		NSDictionary* favorite = [favorites objectAtIndex: i];
		if([[favorite objectForKey:@"resourceId"] isEqual: [resource resourceId]]) {
			[favorites replaceObjectAtIndex: i withObject:dictionary];
			break;
		}
	}
	
	[dictionary release];
}

- (void) removeResourceFromFavorites:(CPMResource*) resource {
	for(NSUInteger i = 0; i < [favorites count]; i++){
		NSDictionary* favorite = [favorites objectAtIndex: i];
		if([[favorite objectForKey:@"resourceId"] isEqual: [resource resourceId]]) {
			[favorites removeObjectAtIndex: i];
			return;
		}
	}
}

- (void) removeFavoriteAtIndex: (NSUInteger) index {
	[favorites removeObjectAtIndex: index];
}

- (void) persistFavorites {
	// Save the Favorites
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsPath = [paths objectAtIndex:0];
	
	// <Application Home>/Documents/Favorites.plist 
	NSString *path = [documentsPath stringByAppendingPathComponent:@"Favorites.plist"];
	[favorites writeToFile:path atomically:YES];
}

- (void) operationDidComplete: (XSResponse*) response {
	if([[response tag] isEqualToString: @"resources.search"]) {
		isSearching = NO;
		BOOL newSearch = [[[response result] offset] intValue] == 0;

		if (newSearch) // New search, clear data
			[searchResults removeAllObjects];
		
		[searchResults addObjectsFromArray: [[response result] results]];
		self.lastSearchResultSet = [response result];
		
		if (newSearch)
			[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName: @"SearchResultsReceived" object: self]];
		else 
			[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName: @"SearchResultsAppended" object: self]];
		
	} else if([[response tag] isEqualToString: @"resources.pull"]) {
		[currentResource release];
		currentResource = [response result];

		// Update the favorite info while we have fresh data
		if([self isResourceInFavorites: currentResource])
			[self updateFavoriteFromResource: currentResource];
		
		[currentResource retain];
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName: @"ResourceDetailsReceived" object: self]];
	} else if ([[response tag] isEqualToString:@"common.get_list"]) {
		if(commonSearches) [commonSearches release];
		commonSearches = [response result];
		[commonSearches retain];
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName: @"CommonSearchesReceived" object: self]];
	}
}

- (void) operationDidFailWithError: (NSDictionary*) errorInfo {
	NSError* error = [errorInfo objectForKey:@"error"];
	NSString* tag = [errorInfo objectForKey:@"tag"];
	NSLog(@"%@", error);
	
	if([tag isEqualToString:@"resources.search"]){
		isSearching = NO;
		[[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName:@"SearchRequestFailed" object:self userInfo:[NSDictionary dictionaryWithObject:error forKey: @"error"]]];
	} else if ([tag isEqualToString:@"resources.pull"]) {
		[[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName:@"ResourceRequestFailed" object:self userInfo:[NSDictionary dictionaryWithObject:error forKey: @"error"]]];
	} else if ([tag isEqualToString:@"common.get_list"]) {
		[[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName:@"CommonSearchesRequestFailed" object:self userInfo:[NSDictionary dictionaryWithObject:error forKey: @"error"]]];
	}
}

- (void) dealloc {
	[operationQueue release], operationQueue = nil;
	[searchResults release], searchResults = nil;
	[currentResource release], currentResource = nil;
	[favorites release], favorites = nil;
	[lastQuery release], lastQuery = nil;
	[lastSearchResultSet release], lastSearchResultSet = nil;
	
	[super dealloc];
}

// Below implements the singleton pattern for this class (from examples online)

static XServicesHelper* sharedHelperInstance = nil;

+ (XServicesHelper*) sharedInstance {
	@synchronized(self){
		if (sharedHelperInstance == nil) {
			sharedHelperInstance = [[self alloc] init];
		}
	}
	return sharedHelperInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedHelperInstance == nil) {
            sharedHelperInstance = [super allocWithZone:zone];
            return sharedHelperInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //never let this be released;
}

- (oneway void)release {
    //prevent release
}

- (id)autorelease {
    return self;
}

// Override to allow manual notifications for the network status properties
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
	return !([theKey isEqualToString:@"internetConnectionAvailable"] || [theKey isEqualToString:@"xServicesReachable"]);
}

@end
