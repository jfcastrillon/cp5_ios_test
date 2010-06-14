//
//  CPMResource.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/4/10.
//  Copyright 2010 Louisiana State University-Shreveport. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CPMResource : NSObject {
	unsigned int	resourceId;
	unsigned int	providerId;
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

@property (nonatomic) unsigned int resourceId;
@property (nonatomic) unsigned int providerId;
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

@end
