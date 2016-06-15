//
//  XSSettingsOperation.m
//  CommunityPointMobile
//
//  Created by Matthew Baker on 5/22/13.
//  Copyright (c) 2013 Bowman Systems, LLC. All rights reserved.
//

#import "XSSettingsOperation.h"

@implementation XSSettingsOperation

- (id) init {
	// Parser for the response data
	id parser = [[CPMSettingsParser alloc] init];
	
	// Let the base class handle the rest
	[super initWithAction: @"accounts.get_settings" andParameters: [NSMutableDictionary dictionary] andParser: parser];
	
	[parser release];
	
	return self;
}


@end
