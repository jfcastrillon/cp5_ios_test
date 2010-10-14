//
//  XServicesRequestOperation.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/16/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "XServicesRequestOperation.h"

NSString* encodeStringForURL(NSString* str){
	return [(NSString*) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) str, (CFStringRef) @"%+#", NULL, CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease];
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
		// Handle NSNumber by converting to string
		else if ([[self objectForKey: currKey] isKindOfClass:[NSNumber class]]) {
			currObject = encodeStringForURL([[self objectForKey: currKey] stringValue]);
			[retval appendString: [NSString stringWithFormat:@"%@=%@", currKey, currObject]];
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

- (id) initWithAction:(NSString*) action andParameters:(NSDictionary*) parameters andParser:(NSObject <ResponseParser>*) parser{
	
	_baseUrl = @"http://syncpoint.bowmansystems.com/xs/1.0/index.php";
	[_baseUrl retain];
	
	_publicKey = @"5240A93C66BEA766B61DC6B54369A696";
	[_publicKey retain];
	
	_action = action;
	[_action retain];
	
	_params = [parameters mutableCopy];
	
	_parser = parser;
	[_parser retain];
	
	[parameters setValue:action forKey:@"method"];
	[parameters setValue:@"json" forKey:@"output"];
	[parameters setValue:@"0.0.0.0" forKey:@"ip"];
	[parameters setValue:_publicKey forKey:@"key"];
	[parameters setValue:@"cp5_ios" forKey:@"client_app"];
	[parameters setValue:@"1.0.0" forKey:@"client_version"];
	
	NSString *deviceString = [NSString stringWithFormat:@"%@ (%@ %@)", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]]; 
	[parameters setValue:deviceString forKey:@"device"];
	
	//Convert the postData to a string
	NSString* paramString = [parameters urlPostEncoded];
	
	// Open and return the connection
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: _baseUrl]];
	[request setHTTPMethod: @"POST"];
	[request setHTTPBody: [NSData dataWithBytes: [paramString UTF8String] length:[paramString length]]];
	
	return [super initWithRequest: request];
}

- (void)dealloc {
	[_params release];
	[_baseUrl release];
	[_publicKey release];
	[_action release];
	[_parser release];
    [super dealloc];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
	[[NetworkManager sharedInstance] showNetworkActivityIndicator];
	return [super connection: connection willSendRequest: request redirectResponse: response];
}

- (void) finishForCancel {
	NSLog(@"Operation cancelled: %@", _action);
	[[NetworkManager sharedInstance] hideNetworkActivityIndicator];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[super connection:connection didFailWithError:error];
	[[NetworkManager sharedInstance] hideNetworkActivityIndicator];
	NSMutableDictionary *errorInfo = [[[NSMutableDictionary alloc] init] autorelease];
	[errorInfo setObject:error forKey:@"error"];
	[errorInfo setObject:_action forKey:@"tag"];
	[delegate performSelectorOnMainThread:@selector(operationDidFailWithError:) withObject:errorInfo waitUntilDone:NO];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[super connectionDidFinishLoading:connection];
	
	[[NetworkManager sharedInstance] hideNetworkActivityIndicator];
	
	//Parse the data
	result = [_parser parseData: [self responseBody]];
	
	if(!self.isCancelled) {
		XSResponse *response = [[[XSResponse alloc] init] autorelease];
		[response setTag: _action];
		[response setResult: result];
		//[result release];
	    [delegate performSelectorOnMainThread:@selector(operationDidComplete:) withObject:response waitUntilDone:NO];
	}
}



@end
