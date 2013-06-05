//
//  XSResponse.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/18/10.
//  Copyright (c) 2010 Bowman Systems, LLC. All rights reserved.
//

#import "XSResponse.h"


@implementation XSResponse

@synthesize tag, result;

- (void) dealloc {
	self.tag = nil;
	self.result = nil;
	[super dealloc];
}

@end
