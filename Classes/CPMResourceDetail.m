//
//  CPMResourceDetail.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/10/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMResourceDetail.h"
#import "CPMResource.h"


@implementation CPMResourceDetail

@synthesize description;
@synthesize services;
@synthesize primaryAddress;
@synthesize addresses;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	[super initFromJsonDictionary: dictionary];
	self.description = nullFix([dictionary objectForKey: @"description"]);
	self.services = nullFix([dictionary objectForKey: @"services"]);
	
	NSDictionary* addressDict = nullFix([dictionary objectForKey: @"addresses"]);
	if(addressDict != nil) {
		NSDictionary* primaryAddressDict = nullFix([addressDict objectForKey:@"primary"]);
		CPMProviderAddress *tempPrimaryAddress = [[CPMProviderAddress alloc] initFromJsonDictionary: primaryAddressDict];
		self.primaryAddress = tempPrimaryAddress;
		
		// Copy these fields over to fill in the super class fields
		self.address1 = [tempPrimaryAddress line1];
		self.address2 = [tempPrimaryAddress line2];
		self.city = [tempPrimaryAddress city];
		self.state = [tempPrimaryAddress province];
		self.zipcode = [NSDecimalNumber decimalNumberWithString: [tempPrimaryAddress postalcode]];
		
		[tempPrimaryAddress release];
		
		
		NSArray *addressBinArray = nullFix([addressDict objectForKey:@"bin"]);
		if(addressBinArray != nil){
			NSMutableArray *addressBin = [[NSMutableArray alloc] initWithCapacity: [addressBinArray count]];
			for(NSDictionary *addressDict in addressBinArray) {
				CPMProviderAddress *tempAddress = [[CPMProviderAddress alloc] initFromJsonDictionary: addressDict];
				[addressBin addObject: tempAddress];
				[tempAddress release];
			}
			self.addresses = addressBin;
			[addressBin release];
		}
	}
	
	return self;
}


@end
