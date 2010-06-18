//
//  XServicesRequestOperation.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/16/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseParser.h"
#import "XSResponse.h"

NSString* encodeStringForURL(NSString* str);

@interface NSDictionary(urlPostEncoded) 
	- (NSString *) urlPostEncoded;
@end

@interface XServicesRequestOperation : NSOperation {

	NSString *_publicKey;
	NSString *_baseUrl;
	NSString *_action;
	
	NSMutableDictionary *_params;
	
	NSURLConnection *_urlConnection;
	NSMutableData *_responseData;
	NSURL *_url;
	
	NSObject <ResponseParser> *_parser;
	id delegate;
	id result;
	
	NSError *lastError;
	
	BOOL finished;
	BOOL executing;
	
	
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) id result;
@property (nonatomic, retain) NSError *lastError;

- (id) initWithAction:(NSString*) action andParameters:(NSDictionary*) parameters andParser: (id <ResponseParser>) parser;

- (void)start;
- (BOOL)isConcurrent;
- (BOOL)isFinished;
- (BOOL)isExecuting;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
