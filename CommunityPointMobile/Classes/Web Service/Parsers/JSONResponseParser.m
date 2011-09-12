//
//  JSONResponseParser.m
//  CommunityPointMobile
//
//  Basis for all response data parsing from the XServices requests.  This takes the
//  raw data received and converts it to an NSDictionary/NSArray depending on the root
//  element type of the JSON.
//
//  Created by John Cannon on 6/17/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "JSONResponseParser.h"
#import "JSON.h"


@implementation JSONResponseParser

- (id) parseData:(NSData*) data {
	//Handle the data
	NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	// keep this here.  it lets you monitor the response data
	// NSLog(@"%@", dataString);
	
	id result = [dataString JSONValue];
	
	[dataString release];
	
	return result;
}

@end
