//
//  XServicesRequestOperation.h
//  CommunityPointMobile
//
//  This is the base class of the NSOperations we use to do asynchronous
//  requests to XServices.  This class tries to provide most of the functionality
//  each request type will need in order to simplify the development of new types.
//
//  Created by John Cannon on 6/16/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHTTPOperation.h"
#import "ResponseParser.h"
#import "XSResponse.h"
#import "NetworkManager.h"

// Escapes characters in a URL string.
NSString* encodeStringForURL(NSString* str);


// This is a category on the NSDictionary class to encode the contents into HTTP POST form
@interface NSDictionary(urlPostEncoded) 
	- (NSString *) urlPostEncoded;
@end

@interface XServicesRequestOperation : QHTTPOperation {

	NSString *_publicKey;	// Key used by XServices to identify and authorize this client
	NSString *_baseUrl;		// Entry point URL for the XServices service
	NSString *_action;		// The action/method this request is to call
	
	NSMutableDictionary *_params;		// The parameters of the request (i.e., query, resource ID, etc)
	
	NSObject <ResponseParser> *_parser;	// The object that will parse the response data
	id delegate;						// What object to notify when an error occurs or the request completes
	id result;							// The result of the operation
	
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) id result;

- (id) initWithAction:(NSString*) action andParameters:(NSDictionary*) parameters andParser: (id <ResponseParser>) parser;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
