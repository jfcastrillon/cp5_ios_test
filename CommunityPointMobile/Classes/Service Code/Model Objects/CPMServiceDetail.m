//
//  CPMServiceDetail.m
//  CommunityPointMobile
//
//  Created by Ben Carver on 6/22/17.
//  Copyright 2017 Bowman Systems, LLC. All rights reserved.
//


#import "CPMServiceDetail.h"
#import "SettingsHelper.h"
#import "Util.h"

@implementation CPMServiceDetail

@synthesize applicationProcess;
@synthesize areaFlexible;
@synthesize availability;
@synthesize availableForDirectory; 
@synthesize availableForReferral; 
@synthesize availableForResearch;
@synthesize capacity; 
@synthesize description; 
@synthesize eligibilityRequirements;
@synthesize feeStructure; 
@synthesize hours; 
@synthesize languages; 
@synthesize notes; 
@synthesize requiredDocuments;
@synthesize serviceArea;
@synthesize resourceContact;
	
- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	//[super initFromJsonDictionary: dictionary];
	if([super init] == nil) return nil;
	self.applicationProcess = nullFix([dictionary objectForKey: @"application_process"]);
	self.areaFlexible = nullFix([dictionary objectForKey: @"area_flexible"]);
	self.availability = nullFix([dictionary objectForKey: @"availability"]);
	self.availableForDirectory = nullFix([dictionary objectForKey: @"available_for_directory"]);
	self.availableForReferral = nullFix([dictionary objectForKey: @"available_for_referral"]);
	self.availableForResearch = nullFix([dictionary objectForKey: @"available_for_research"]);
	self.capacity = nullFix([dictionary objectForKey: @"capacity"]);
	self.description = nullFix([dictionary objectForKey: @"description"]);
	self.eligibilityRequirements = nullFix([dictionary objectForKey: @"eligibility_requirements"]);
	self.feeStructure = nullFix([dictionary objectForKey: @"fee_structure"]);
	self.hours = nullFix([dictionary objectForKey: @"hours"]);
	self.languages = nullFix([dictionary objectForKey: @"languages"]);
	self.notes = nullFix([dictionary objectForKey: @"notes"]);
	self.requiredDocuments = nullFix([dictionary objectForKey: @"required_documents"]);
    self.serviceArea = nullFix([dictionary objectForKey: @"service_area"]);
	
	// extract resource contacts
	NSDictionary* contactDict = nullFix([dictionary objectForKey: @"resource_contact"]);
        if(contactDict != nil) {
            CPMResourceContact *tempContact = [[CPMResourceContact alloc] initFromJsonDictionary: contactDict];
            self.resourceContact = tempContact;
        }
    
    
    
   	
	return self;
}

- (void) dealloc {
	self.applicationProcess = nil;
	self.areaFlexible = nil;
	self.availability = nil;
	self.availableForDirectory = nil;
	self.availableForReferral = nil;
	self.availableForReferral = nil;
	self.availableForResearch = nil;
	self.capacity = nil;
	self.description = nil;
	self.eligibilityRequirements = nil;
	self.feeStructure = nil;
	self.hours = nil;
	self.languages = nil;
	self.notes = nil;
	self.requiredDocuments = nil;
    self.serviceArea = nil;
	self.resourceContact = nil;
	
	[super dealloc];
}



@end


