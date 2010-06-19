//
//  CPMProviderAddress.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/18/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum CPMProviderAddressType {
	CPMPhysicalAddress,
	CPMMailingAddress
} CPMProviderAddressType;

@interface CPMProviderAddress : NSObject {
	NSDecimalNumber *addressId;
	CPMProviderAddressType type;
	NSNumber *active;
	NSString *description;
	NSString *line1;
	NSString *line2;
	NSString *city;
	NSString *province;
	NSString *postalcode;
	NSString *county;
	NSString *country;
	NSString *landmarks;
}

@property (nonatomic, copy) NSDecimalNumber* addressId;
@property (nonatomic, assign) CPMProviderAddressType type;
@property (nonatomic, copy) NSNumber* active;
@property (nonatomic, copy) NSString* description;
@property (nonatomic, copy) NSString* line1;
@property (nonatomic, copy) NSString* line2;
@property (nonatomic, copy) NSString* city;
@property (nonatomic, copy) NSString* province;
@property (nonatomic, copy) NSString* postalcode;
@property (nonatomic, copy) NSString* county;
@property (nonatomic, copy) NSString* country;
@property (nonatomic, copy) NSString* landmarks;

- (NSString*) multilineStringValue;
- (NSString*) stringValue;

@end
