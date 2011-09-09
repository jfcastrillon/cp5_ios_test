//
//  XServicesCommonSearchListOperation.m
//  CommunityPointMobile
//
//  Created by John Cannon on 10/21/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "XSCommonSearchListOperation.h"


@implementation XSCommonSearchListOperation

- (id) init {
	//if([super init] == nil) return nil;
	
	// Parser for the response data
	id parser = [[CPMCommonSearchParser alloc] init];
	
	// Let the base class handle the rest
	[super initWithAction: @"common.get_list" andParameters: [NSMutableDictionary dictionary] andParser: parser];
	
	[parser release];
	
	return self;
}


@end
