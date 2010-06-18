//
//  XSResourceDetailsOperation.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "XSResourceDetailsOperation.h"
#import "CPMResourceDetailParser.h"


@implementation XSResourceDetailsOperation

- (id) initWithResourceId: (NSUInteger) resourceId {
	if([super init] == nil) return nil;
	
	
	// Setup method call paramters
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setValue: [[NSDecimalNumber numberWithUnsignedInt: resourceId] stringValue] forKey:@"id"];
	[params setValue: @"external" forKey:@"source"];	
	
	// Parser for the response data
	id parser = [[CPMResourceDetailParser alloc] init];
	
	// Let the base class handle the rest
	[super initWithAction: @"resources.pull" andParameters: params andParser: parser];
	
	[params release];
	[parser release];
	
	return self;
}

@end
