//
//  XSResponse.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
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
