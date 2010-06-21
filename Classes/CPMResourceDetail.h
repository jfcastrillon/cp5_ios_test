//
//  CPMResourceDetail.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/10/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPMBoolean.h"
#import "CPMResource.h"
#import "CPMProviderAddress.h"
#import "CPMProviderTelephone.h"

@interface CPMResourceDetail : CPMResource {
	NSString		*description;
	NSDictionary	*services;
	
	CPMProviderAddress *primaryAddress;
	NSArray			*addresses;
	CPMProviderTelephone *primaryPhone;
	NSArray			*phones;
	
	NSString* hours;
	NSString* programFees;
	NSString* languages;
	NSString* eligibility;
	NSString* intakeProcedure;
	CPMBoolean* accessibilityFlag;
	CPMBoolean* shelterFlag;
	NSString* shelterRequirements;
}

@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSDictionary *services;

@property (nonatomic, retain) CPMProviderAddress *primaryAddress;
@property (nonatomic, copy) NSArray *addresses;
@property (nonatomic, copy) NSArray *phones;
@property (nonatomic, retain) CPMProviderTelephone* primaryPhone;

@property (nonatomic, copy) NSString* hours;
@property (nonatomic, copy) NSString* programFees;
@property (nonatomic, copy) NSString* languages;
@property (nonatomic, copy) NSString* eligibility;
@property (nonatomic, copy) NSString* intakeProcedure;
@property (nonatomic, copy) CPMBoolean* accessibilityFlag;
@property (nonatomic, copy) CPMBoolean* shelterFlag;
@property (nonatomic, copy) NSString* shelterRequirements;

@end
