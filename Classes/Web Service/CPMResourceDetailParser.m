//
//  CPMResourceDetailParser.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/17/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMResourceDetailParser.h"
#import "CPMResourceDetail.h"


@implementation CPMResourceDetailParser

- (id) parseData:(NSData*) data {
	id jsonResult = [super parseData: data];
	
	CPMResourceDetail *result = [[CPMResourceDetail alloc] initFromJsonDictionary:[jsonResult objectForKey: @"resource"]];
	
	//[jsonResult release];
	
	return result;
}

@end