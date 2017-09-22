//
//  CPMServiceDetail.h
//  CommunityPointMobile
//
//  Created by Ben Carver on 6/22/17.
//  Copyright 2017 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPMBoolean.h"
#import "CPMResourceContact.h"

@interface CPMServiceDetail : NSObject {
	NSString		*applicationProcess;
	CPMBoolean* areaFlexible;
	NSString		*availability;
	CPMBoolean* availableForDirectory; 
	CPMBoolean* availableForReferral; 
	CPMBoolean* availableForResearch;
	NSString		*capacity; 
	NSString		*description; 
	NSString		*eligibilityRequirements;
	NSString		*feeStructure; 
	NSString		*hours; 
	NSString		*languages; 
	NSString		*notes; 
	NSString		*requiredDocuments; 
	CPMResourceContact* resourceContact;
	NSString		*serviceArea;
	
}


@property (nonatomic, copy) NSString *applicationProcess;
@property (nonatomic, copy) CPMBoolean* areaFlexible;
@property (nonatomic, copy) NSString *availability;
@property (nonatomic, copy) CPMBoolean* availableForDirectory;
@property (nonatomic, copy) CPMBoolean* availableForReferral;
@property (nonatomic, copy) CPMBoolean* availableForResearch;
@property (nonatomic, copy) NSString *capacity;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *eligibilityRequirements;
@property (nonatomic, copy) NSString *feeStructure;
@property (nonatomic, copy) NSString *hours;
@property (nonatomic, copy) NSString *languages;
@property (nonatomic, copy) NSString *notes; 
@property (nonatomic, copy) NSString *requiredDocuments; 
@property (nonatomic, copy) CPMResourceContact* resourceContact;
@property (nonatomic, copy) NSString *serviceArea;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary;
- (NSDictionary*) dictionaryValue;


@end


