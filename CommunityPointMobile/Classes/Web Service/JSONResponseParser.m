//
//  JSONResponseParser.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/17/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "JSONResponseParser.h"


@implementation JSONResponseParser

- (id) parseData:(NSData*) data {
	//Handle the data
	NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	return [dataString JSONValue];
}

@end
