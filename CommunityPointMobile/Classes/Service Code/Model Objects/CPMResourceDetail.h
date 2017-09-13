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
#import "CPMProviderTelephone.h"
#import "CPMService.h"
#import "CPMUnitInfo.h"

@interface CPMResourceDetail : CPMResource {
	NSString		*description;
	NSDictionary	*services;
    NSDictionary	*serviceDetails;
	
	CPMProviderAddress *primaryAddress;
	NSArray			*addresses;
	CPMProviderTelephone *primaryPhone;
	NSArray			*phones;
    NSArray         *unitInfos;
	
	NSString* hours;
	NSString* programFees;
	NSString* languages;
	NSString* eligibility;
	NSString* intakeProcedure;
	NSString* shelterRequirements;
}

@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSDictionary *services;
@property (nonatomic, copy) NSDictionary *serviceDetails;

@property (nonatomic, retain) CPMProviderAddress *primaryAddress;
@property (nonatomic, copy) NSArray *addresses;
@property (nonatomic, copy) NSArray *phones;
@property (nonatomic, retain) CPMProviderTelephone* primaryPhone;
@property (nonatomic, copy) NSArray *unitInfos;

@property (nonatomic, copy) NSString* hours;
@property (nonatomic, copy) NSString* programFees;
@property (nonatomic, copy) NSString* languages;
@property (nonatomic, copy) NSString* eligibility;
@property (nonatomic, copy) NSString* intakeProcedure;
@property (nonatomic, copy) NSString* shelterRequirements;

@end
