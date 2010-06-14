//
//  XServicesHelper.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kXServicesNoOperation		0
#define kXServicesSearchResults		100
#define kXServicesProviderCount		200
#define kXServicesProviderDetails	300

@interface XServicesHelper : NSObject {
	NSString *privateKey;
	NSString *publicKey;
	NSString *baseUrl;
	NSMutableData* responseData;
	NSURLConnection *currentConnection;
	IBOutlet id delegate;
	int currentOperation;
}

@property (nonatomic, retain) NSString *privateKey;
@property (nonatomic, retain) NSString *publicKey;
@property (nonatomic, retain) NSString *baseUrl;
@property (nonatomic, retain) IBOutlet id delegate;

- (id) initWithBaseUrl:(NSString*) baseUrl andPublicKey:(NSString*) publicKey;
- (NSURLConnection*) createConnectionForUrl: (NSString*)url withPostData: (NSDictionary*)postData;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

// XServices simplified methods
- (void)searchResourcesWithQuery:(NSString*)query;
- (void)retrieveProviderCount;
- (void)retrieveResourceDetails: (NSDecimalNumber*) resourceId;

- (BOOL) busy;
- (void) cancel;

@end
