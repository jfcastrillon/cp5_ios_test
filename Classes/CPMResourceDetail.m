//
//  CPMResourceDetail.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/10/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMResourceDetail.h"
#import "CPMResource.h"
#import "CPMService.h"
#import "Util.h"

@implementation CPMResourceDetail

@synthesize description;
@synthesize services;
@synthesize primaryAddress;
@synthesize addresses;

@synthesize hours, programFees, languages, eligibility, intakeProcedure, accessibilityFlag, shelterRequirements, shelterFlag;

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
		self.zipcode = [tempPrimaryAddress postalcode];
		
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
	
	NSMutableDictionary *servicesDict = [[NSMutableDictionary alloc] init];
	
	NSMutableArray *primaryArray = [[NSMutableArray alloc] init];
	NSMutableArray *secondaryArray = [[NSMutableArray alloc] init];
	NSMutableArray *occasionalArray = [[NSMutableArray alloc] init];
	
	[servicesDict setObject:primaryArray forKey:@"primary"];
	[servicesDict setObject:secondaryArray forKey:@"secondary"];
	[servicesDict setObject:occasionalArray forKey:@"occasional"];
	
	self.services = servicesDict;
	[servicesDict release], servicesDict = nil;
	
	
	if(nullFix([dictionary objectForKey:@"services"]) != nil) {
		NSDictionary* primaryServicesJson = nullFix([dictionary valueForKeyPath: @"services.1"]);
		if (primaryServicesJson != nil) {
			for (NSDictionary* serviceDict in [primaryServicesJson allValues]) {
				CPMService* service = [[CPMService alloc] initFromJsonDictionary: serviceDict];
				[primaryArray addObject: service];
				[service release];
			}
		}
		
		NSDictionary* secondaryServicesJson = nullFix([dictionary valueForKeyPath: @"services.2"]);
		if (secondaryServicesJson != nil) {
			for (NSDictionary* serviceDict in [secondaryServicesJson allValues]) {
				CPMService* service = [[CPMService alloc] initFromJsonDictionary: serviceDict];
				[secondaryArray addObject: service];
				[service release];
			}
		}
		
		NSDictionary* occasionalServicesJson = nullFix([dictionary valueForKeyPath: @"services.3"]);
		if (occasionalServicesJson != nil) {
			for (NSDictionary* serviceDict in [occasionalServicesJson allValues]) {
				CPMService* service = [[CPMService alloc] initFromJsonDictionary: serviceDict];
				[occasionalArray addObject: service];
				[service release];
			}
		}
	}
	
	[primaryArray release], primaryArray = nil;
	[secondaryArray release], secondaryArray = nil;
	[occasionalArray release], occasionalArray = nil;
												
	self.hours = nullFix([dictionary objectForKey:@"hours"]);
	self.eligibility = nullFix([dictionary objectForKey:@"eligibility"]);
	self.programFees = nullFix([dictionary objectForKey:@"programFees"]);
	self.languages = nullFix([dictionary objectForKey:@"languages"]);
	self.intakeProcedure = nullFix([dictionary objectForKey:@"intake_procedure"]);
	self.shelterRequirements = nullFix([dictionary objectForKey:@"shelter_requirements"]);
	
	self.accessibilityFlag = nullFix([dictionary objectForKey:@"accessibility_flag"]);
	self.shelterFlag = nullFix([dictionary objectForKey:@"shelter_flag"]);
	
	return self;
}


@end
