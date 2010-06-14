//
//  CPMResourceDetail.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/10/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPMResource.h"

@interface CPMResourceDetail : CPMResource {
	NSString		*description;
	NSDictionary	*services;
}

@property (nonatomic, copy) NSString* description;
@property (nonatomic, retain) NSDictionary* services;

@end
