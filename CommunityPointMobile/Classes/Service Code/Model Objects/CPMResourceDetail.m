//
//  CPMResourceDetail.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/10/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMResourceDetail.h"
#import "SettingsHelper.h"
#import "Util.h"

@implementation CPMResourceDetail

@synthesize description;
@synthesize services;
@synthesize primaryAddress;
@synthesize addresses;
@synthesize phones, primaryPhone;
@synthesize unitInfos;
@synthesize hours, programFees, languages, eligibility, intakeProcedure, shelterRequirements;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	[super initFromJsonDictionary: dictionary];
	self.description = nullFix([dictionary objectForKey: @"description"]);
	self.services = nullFix([dictionary objectForKey: @"services"]);
	
    // Extract Unit Infos
    id unitInfosParse = nullFix([dictionary objectForKey:@"unitInfo"]);
    if (unitInfosParse != nil && [unitInfosParse isKindOfClass:[NSArray class]]) {
        NSMutableArray *unitInfoBin = [[NSMutableArray alloc] initWithCapacity: [(NSArray *)unitInfosParse count]];
        for (NSDictionary *unitDict in unitInfosParse) {
            CPMUnitInfo *unitInfo = [[CPMUnitInfo alloc] initFromJsonDictionary: unitDict];
            [unitInfoBin addObject: unitInfo];
            [unitInfo release];
        }
        self.unitInfos = unitInfoBin;
        [unitInfoBin release];
    }
    
	//Extract addresses
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
	
	//Extract phone numbers
    // If this is an IRIS site, the primary phone is stored as a contact
    if ([[[[SettingsHelper sharedInstance] settings] objectForKey:@"irisSite"] boolValue]) {
        NSDecimalNumber	*primaryPhoneId = nullFix([dictionary objectForKey:@"primary_phone_id"]);
        if(primaryPhoneId != nil) {
            NSDictionary* contactsDict = nullFix([dictionary objectForKey: @"contacts"]);
            if(contactsDict != nil) {
                NSDictionary* binDict = nullFix([contactsDict objectForKey: @"bin"]);
                if(binDict != nil) {
                    NSDictionary* primaryPhoneDict = nullFix([binDict objectForKey:[NSString stringWithFormat:@"%@", [primaryPhoneId stringValue]]]);
                    if(primaryPhoneDict != nil) {
                        CPMProviderTelephone *tempPrimaryPhone = [[CPMProviderTelephone alloc] initFromJsonDictionary: primaryPhoneDict];
                        self.primaryPhone = tempPrimaryPhone;
                        
                        // Copy these fields over to fill in the super class fields
                        self.phone = [tempPrimaryPhone fullNumber];
                        
                        [tempPrimaryPhone release];

                        NSArray *phoneBinArray = [binDict allValues];
                        NSMutableArray *phoneBin = [[NSMutableArray alloc] initWithCapacity: [phoneBinArray count]];
                        for(NSDictionary *phoneDict in phoneBinArray) {
                            CPMProviderTelephone *tempPhone = [[CPMProviderTelephone alloc] initFromJsonDictionary: phoneDict];
                            [phoneBin addObject: tempPhone];
                            [tempPhone release];
                        }
                        self.phones = phoneBin;
                        [phoneBin release];
                    }
                }
            }
        }
    }
    // If this is not an IRIS site, the phones are stored in a 'phones' array.
    else {
        NSDictionary* phoneDict = nullFix([dictionary objectForKey: @"phones"]);
        if(phoneDict != nil) {
            NSDictionary* primaryPhoneDict = nullFix([phoneDict objectForKey:@"primary"]);
            CPMProviderTelephone *tempPrimaryPhone = [[CPMProviderTelephone alloc] initFromJsonDictionary: primaryPhoneDict];
            self.primaryPhone = tempPrimaryPhone;
            
            // Copy these fields over to fill in the super class fields
            self.phone = [tempPrimaryPhone fullNumber];
            
            [tempPrimaryPhone release];
            
            if(nullFix([phoneDict objectForKey:@"bin"]) != nil){
                NSArray *phoneBinArray = [[phoneDict objectForKey:@"bin"] allValues];
                NSMutableArray *phoneBin = [[NSMutableArray alloc] initWithCapacity: [phoneBinArray count]];
                for(NSDictionary *phoneDict in phoneBinArray) {
                    CPMProviderTelephone *tempPhone = [[CPMProviderTelephone alloc] initFromJsonDictionary: phoneDict];
                    [phoneBin addObject: tempPhone];
                    [tempPhone release];
                }
                self.phones = phoneBin;
                [phoneBin release];
            }
        }
    }
	
	
	//Extract services
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
	self.programFees = nullFix([dictionary objectForKey:@"program_fees"]);
	self.languages = nullFix([dictionary objectForKey:@"languages"]);
	self.intakeProcedure = nullFix([dictionary objectForKey:@"intake_procedure"]);
	self.shelterRequirements = nullFix([dictionary objectForKey:@"shelter_requirements"]);
	
	self.accessibilityFlag = nullFix([dictionary objectForKey:@"accessibility_flag"]);
	self.isShelter = nullFix([dictionary objectForKey:@"is_shelter"]);
	
	return self;
}

- (void) dealloc {
	self.description = nil;
	self.services = nil;
	self.primaryAddress = nil;
	self.addresses = nil;
	
	self.phones = nil;
	self.primaryPhone = nil;
    self.unitInfos = nil;
	
	self.hours = nil;
	self.programFees = nil;
	self.languages = nil;
	self.eligibility = nil;
	self.intakeProcedure = nil;
	self.accessibilityFlag = nil;
	self.shelterRequirements = nil;
	self.isShelter = nil;
	[super dealloc];
}


@end
