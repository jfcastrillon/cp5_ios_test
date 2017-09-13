//
//  CPMService.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/21/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPMServiceDetail.h"
#import "CPMServiceTelephone.h"


@interface CPMService : NSObject {
	NSString	*code;
	NSString	*name;
	CPMServiceDetail *serviceDetails;
    CPMServiceTelephone *serviceTelephones;
    NSArray	*telephones;

}

@property (nonatomic, copy) NSString* code;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, retain) CPMServiceDetail* serviceDetails;
@property (nonatomic, retain) CPMServiceTelephone* serviceTelephones;
@property (nonatomic, copy) NSArray* telephones;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary;

@end
