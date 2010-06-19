//
//  CPMResource.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/4/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Util.h"


@interface CPMResource : NSObject {
	NSDecimalNumber	*resourceId;
	NSDecimalNumber	*providerId;
	NSString		*name;
	NSString		*address1;
	NSString		*address2;
	NSString		*city;
	NSString		*state;
	NSString		*zipcode;
	NSString		*url;
	NSString		*phone;
	NSDecimalNumber	*latitude;
	NSDecimalNumber	*longitude;	
}

@property (nonatomic, copy) NSDecimalNumber *resourceId;
@property (nonatomic, copy) NSDecimalNumber *providerId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address1;
@property (nonatomic, copy) NSString *address2;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zipcode;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSDecimalNumber *latitude;
@property (nonatomic, copy) NSDecimalNumber *longitude;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary;

- (NSString*) addressString;

@end
