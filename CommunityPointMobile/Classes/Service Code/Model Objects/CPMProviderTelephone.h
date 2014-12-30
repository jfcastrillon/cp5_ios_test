//
//  CPMProviderTelephone.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/21/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CPMProviderTelephone : NSObject {
	NSDecimalNumber	*telephoneId;
	NSString	*name;
	NSString	*areaCode;
	NSString	*prefix;
	NSString	*line;
	NSString	*extension;
	NSString	*fullNumber;
}

@property (nonatomic, copy) NSDecimalNumber* telephoneId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* areaCode;
@property (nonatomic, copy) NSString* prefix;
@property (nonatomic, copy) NSString* line;
@property (nonatomic, copy) NSString* extension;
@property (nonatomic, copy) NSString* fullNumber;


- (id) initFromJsonDictionary: (NSDictionary*) dictionary;

@end
