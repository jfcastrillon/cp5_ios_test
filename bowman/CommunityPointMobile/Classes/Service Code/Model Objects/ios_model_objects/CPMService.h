//
//  CPMService.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/21/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPMServiceDetail.h"


@interface CPMService : NSObject {
	NSString	*code;
	NSString	*name;
	CPMServiceDetail *serviceDetails;
}

@property (nonatomic, copy) NSString* code;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) CPMServiceDetail* serviceDetails;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary;

@end
