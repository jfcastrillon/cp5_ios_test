//
//  CPMSettingsParser.m
//  CommunityPointMobile
//
//  Created by Matthew Baker on 5/22/13.
//  Copyright (c) 2013 Bowman Systems, LLC. All rights reserved.
//

#import "CPMSettingsParser.h"

@implementation CPMSettingsParser

- (id) parseData:(NSData*) data {
	id jsonResult = [super parseData: data];
	
	CPMSettings *result = [[CPMSettings alloc] initFromJsonDictionary:[jsonResult objectForKey: @"settings"]];
	
	return [result autorelease];
}

@end
