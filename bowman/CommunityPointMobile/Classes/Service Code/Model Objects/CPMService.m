//
//  CPMService.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/21/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMService.h"
#import "Util.h"

@implementation CPMService

@synthesize name, code;
@synthesize serviceDetails;
@synthesize serviceTelephones, telephones;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	if([super init] == nil) return nil;
	self.name = nullFix([dictionary objectForKey: @"name"]);
	self.code = nullFix([dictionary objectForKey: @"code"]);
    
	
	// extract service details
	NSDictionary* detailsDict = nullFix([dictionary objectForKey: @"details"]);
            if(detailsDict != nil) {
            CPMServiceDetail *tempDetails = [[CPMServiceDetail alloc] initFromJsonDictionary: detailsDict];
            self.serviceDetails = tempDetails;
        }
    
    // extract service telephone numbers
    NSDictionary* phoneDict = nullFix([dictionary objectForKey: @"telephone_numbers"]);
    
    if(phoneDict != nil){
        if(nullFix([phoneDict objectForKey:@"bin"]) != nil){
            NSArray *phoneBinArray = nullFix([phoneDict objectForKey:@"bin"]);
    
            NSMutableArray *phoneBin = [[NSMutableArray alloc] initWithCapacity: [phoneBinArray count]];
            for(NSDictionary *phoneDict in phoneBinArray) {
                CPMServiceTelephone *tempPhone = [[CPMServiceTelephone alloc] initFromJsonDictionary: phoneDict];
                [phoneBin addObject: tempPhone];
                [tempPhone release];
            }
            self.telephones = phoneBin;
            [phoneBin release];
        }

    }

	return self;
}

- (void) dealloc {
	self.name = nil;
	self.code = nil;
	[super dealloc];
}

@end
