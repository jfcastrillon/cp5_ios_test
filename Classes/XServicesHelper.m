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

@synthesize searchResults, currentResource, favorites;

- (id) init {
	if([super init] == nil) return nil;
	operationQueue = [[NSOperationQueue alloc] init];
	if(operationQueue == nil) return nil;
	
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
		[favorites writeToFile:installpath atomically:YES];
	} else {
		[favorites release];
		favorites = tmpArray;
	}
	
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
	[favorites addObject: dictionary];
	[dictionary release];
}


// Updates the cached information about the favorite (i.e., when it is reloaded from the server)
- (void) updateFavoriteFromResource:(CPMResource*) resource {
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
	[dictionary setObject: [resource resourceId] forKey: @"resourceId"];
	[dictionary setObject: [resource name] forKey: @"name"];
	[dictionary setObject: [resource addressString] forKey: @"address"];
	
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
		if ([[[response result] offset] intValue] == 0)
			[searchResults removeAllObjects];
		[searchResults addObjectsFromArray: [[response result] results]];
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName: @"SearchResultsReceived" object: self]];
		
		[response release];
	} else if([[response tag] isEqualToString: @"resources.pull"]) {
		currentResource = [response result];
		
		// Update the favorite info while we have fresh data
		if([self isResourceInFavorites: currentResource])
			[self updateFavoriteFromResource: currentResource];
		
		[currentResource retain];
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName: @"ResourceDetailsReceived" object: self]];
		[response release];
	}
}

- (void) operationDidFailWithError: (NSError*) error {
	NSLog(@"%@", error);
}

- (void) dealloc {
	[operationQueue release], operationQueue = nil;
	[searchResults release], searchResults = nil;
	[favorites release], favorites = nil;
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

- (void)release {
    //prevent release
}

- (id)autorelease {
    return self;
}

@end
