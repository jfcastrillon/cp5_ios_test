//
//  XServicesRequestOperation.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/16/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "XServicesRequestOperation.h"

NSString* encodeStringForURL(NSString* str){
	return (NSString*) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) str, (CFStringRef) @"%+#", NULL, CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

@implementation NSDictionary(urlPostEncoded)
- (NSString *) urlPostEncoded
{
	NSEnumerator *keys = [self keyEnumerator];
	NSString *currKey;
	NSString *currObject;
	NSMutableString *retval = [NSMutableString  stringWithCapacity: 256];
	BOOL started = NO;
	while ((currKey = [keys nextObject]) != nil)
	{
		//   Chain the key-value pairs, properly escaped, in one string.
		if (started)
			[retval appendString: @"&"];
		else
			started = YES;
		
		currKey = encodeStringForURL(currKey);
		
		// modified to handle multi-valued keys as arrays of NSString
		if ( [[self objectForKey: currKey] isKindOfClass:[NSArray class]] )
		{
			NSArray *currList = [self objectForKey: currKey];
			int i = 0;
			for ( i = 0 ; i < [currList count] ; i++ )
			{
				if (i > 0) [retval appendString:@"&"];
				currObject = encodeStringForURL([currList objectAtIndex:i]);
				[retval appendString: [NSString stringWithFormat:@"%@=%@", currKey, currObject]];
			}
		}
		else
		{
			currObject = encodeStringForURL([self objectForKey: currKey]);
			[retval appendString: [NSString stringWithFormat:@"%@=%@", currKey, currObject]];
		}
	}
	return retval;
}
@end

@implementation XServicesRequestOperation

@synthesize delegate;
@synthesize result;
@synthesize lastError;

- (id) initWithAction:(NSString*) action andParameters:(NSDictionary*) parameters andParser:(NSObject <ResponseParser>*) parser{
	
	if([super init] == nil) return nil;
	
	_baseUrl = @"http://syncpoint.bowmansystems.com/xs/1.0/index.php";
	[_baseUrl retain];
	
	_publicKey = @"B47182694EA9167F4A6320B775636039";
	[_publicKey retain];
	
	_action = action;
	[_action retain];
	
	_params = [parameters mutableCopy];
	
	_parser = parser;
	[_parser retain];
	
	return self;
}

- (void)dealloc {
	// Close the connection
	[_urlConnection release];
	_urlConnection = nil;
	
	[_params release];
	[_baseUrl release];
	[_publicKey release];
	[_action release];
	[_parser release];
	[_responseData release];
	self.delegate = nil;
	self.lastError = nil;
    [super dealloc];
}

- (NSURLConnection*) createConnectionForUrl: (NSString*)url withPostData: (NSDictionary*)postData {
	_responseData = [[NSMutableData data] retain];
	
	//Convert the postData to a string
	NSString* paramString = [postData urlPostEncoded];
	
	// Open and return the connection
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[request setHTTPMethod: @"POST"];
	[request setHTTPBody: [NSData dataWithBytes: [paramString UTF8String] length:[paramString length]]];
	
	NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];	
	return urlConnection;
}

- (NSURLConnection*) createConnectionForAction: (NSString*)action withParameters:(NSMutableDictionary*)parameters {
	[parameters setValue:action forKey:@"method"];
	[parameters setValue:@"json" forKey:@"output"];
	[parameters setValue:@"0.0.0.0" forKey:@"ip"];
	[parameters setValue:_publicKey forKey:@"key"];
	
	return [self createConnectionForUrl: _baseUrl withPostData:parameters];
}

- (void)start { 
	if(![NSThread isMainThread]){
		// Important for NSURLConnection to run.  This starts the async download and passes control back to the app
		[self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
		return;
	}
	
	if (![self isCancelled]) {
		[self willChangeValueForKey:@"isExecuting"];
		executing = YES;
		_urlConnection = [self createConnectionForAction: _action withParameters: _params];
		[_urlConnection start];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
		
		[self didChangeValueForKey:@"isExecuting"];
	} else {
		// If it's already been cancelled, mark the operation as finished.
		[self willChangeValueForKey:@"isFinished"];
		finished = YES;
		[self didChangeValueForKey:@"isFinished"];
	}
}

- (BOOL)isConcurrent {
	return YES;
}

- (BOOL)isFinished {
	return finished;
}

- (BOOL)isExecuting {
	return executing;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if(self.isCancelled)
		[connection cancel];
	else
		[_responseData setLength: 0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if(self.isCancelled)
		[connection cancel];
	else
		[_responseData appendData:data];
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];	
	self.lastError = error;
	[delegate performSelectorOnMainThread:@selector(requestDidFailWithError:) withObject:error waitUntilDone:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Retrieved %d bytes", [_responseData length]);
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];	
	
	//Parse the data
	result = [_parser parseData: _responseData];
	[_responseData release], _responseData = nil;
	
	[self willChangeValueForKey:@"isFinished"];
	[self willChangeValueForKey:@"isExecuting"];
	finished = YES;
	executing = NO;
	[self didChangeValueForKey:@"isExecuting"];
	[self didChangeValueForKey:@"isFinished"];
	
	if(!self.isCancelled) {
		XSResponse *response = [[XSResponse alloc] init];
		[response setTag: _action];
		[response setResult: result];
	    [delegate performSelectorOnMainThread:@selector(operationDidComplete:) withObject:response waitUntilDone:NO];
	}
}



@end
