//
//  XServicesHelper.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/2/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "XServicesHelper.h"
#import "JSON/JSON.h"
#import "CPMResource.h"
#import "CPMResourceDetail.h"

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

NSArray* translateResourceArray(NSArray* jsonArray) {
	NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity: [jsonArray count]];
	for(NSDictionary* jsonResource in jsonArray) {
		CPMResource* newResource = [[CPMResource alloc] initFromJsonDictionary:jsonResource];
		[results addObject:newResource];
		[newResource release];
	}
	return results;
}

@implementation XServicesHelper

@synthesize delegate;
@synthesize privateKey;
@synthesize publicKey;
@synthesize baseUrl;

- (NSURLConnection*) createConnectionForMethod: (NSString*)method withParameters:(NSMutableDictionary*)parameters {
	[parameters setValue:method forKey:@"method"];
	[parameters setValue:@"json" forKey:@"output"];
	[parameters setValue:@"0.0.0.0" forKey:@"ip"];
	[parameters setValue:publicKey forKey:@"key"];
	
	return [self createConnectionForUrl:baseUrl withPostData:parameters];
}

- (NSURLConnection*) createConnectionForUrl: (NSString*)url withPostData: (NSDictionary*)postData {
	// Only one connection per helper at a time
	if(currentConnection != nil){
		NSLog(@"There is a connection in progress...");
		return nil;
	}
	
	responseData = [[NSMutableData data] retain];
	
	//Convert the postData to a string
	NSString* paramString = [postData urlPostEncoded];
	
	// Open and return the connection
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[request setHTTPMethod: @"POST"];
	[request setHTTPBody: [NSData dataWithBytes: [paramString UTF8String] length:[paramString length]]];
	
	currentConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
	return currentConnection;
}

- (id) initWithBaseUrl:(NSString*) baseUrl andPublicKey:(NSString*) publicKey {
	self.baseUrl = baseUrl;
	self.publicKey = publicKey;			
	currentOperation = kXServicesNoOperation;
	return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength: 0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	// TODO: Handle error
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// Close the connection
	[connection release];
	currentConnection = nil;
	
	//Handle the data
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
	
	NSLog(@"%@", responseString);
	
	NSDictionary* results = [responseString JSONValue];
    [responseString release];
	
	switch (currentOperation) {
		case kXServicesSearchResults:
			[delegate didReceiveSearchResults: translateResourceArray([[results objectForKey: @"resources"] objectForKey: @"results"])];
			break;
		case kXServicesProviderCount:
			[delegate didReceiveProviderCount: results];
			break;
		case kXServicesProviderDetails:
		{
			CPMResourceDetail *resource = [[CPMResourceDetail alloc] initFromJsonDictionary:[results objectForKey: @"resource"]];
			[delegate didReceiveProviderDetails: resource];
            [resource release];
			break;
		}
		default:
			//[results release];
			break;
	}
	
	currentOperation = kXServicesNoOperation;
	
}


// XServices simplified methods
- (void)searchResourcesWithQuery:(NSString*)query {
	// May be a bug here with this being set even if a connection is up...
	currentOperation = kXServicesSearchResults;	
	
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setValue:@"-1" forKey:@"search_history_id"];
	[params setValue:@"50" forKey:@"limit"];	
	[params setValue:query forKey:@"query"];
	[self createConnectionForMethod:@"resources.search" withParameters:params];
}

- (void)retrieveProviderCount {
	// May be a bug here with this being set even if a connection is up...
	currentOperation = kXServicesProviderCount;	
	
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	
	[self createConnectionForMethod:@"accounts.get_info" withParameters:params];
}

- (void) retrieveResourceDetails:(NSDecimalNumber*)resourceId{
	// May be a bug here with this being set even if a connection is up...
	currentOperation = kXServicesProviderDetails;	
	
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];

	[params setValue:@"source" forKey:@"external"];
	[params setValue:[resourceId stringValue] forKey:@"id"];
	
	[self createConnectionForMethod:@"resources.pull" withParameters:params];
}


- (BOOL) busy {
	return (currentConnection != nil);
}

- (void) cancel {
	if(currentConnection != nil)
		[currentConnection cancel];
}

@end
