//
//  CPMResourceDetail.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/10/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPMResource.h"
#import "CPMProviderAddress.h"

@interface CPMResourceDetail : CPMResource {
	NSString		*description;
	NSDictionary	*services;
	CPMProviderAddress *primaryAddress;
	NSArray			*addresses;
}

@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSDictionary *services;
@property (nonatomic, retain) CPMProviderAddress *primaryAddress;
@property (nonatomic, copy) NSArray *addresses;

@end
