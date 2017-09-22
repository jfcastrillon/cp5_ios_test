//
//  CPMResourceContact.h
//  CommunityPointMobile
//
//  Created by Ben Carver on 6/22/17.
//  Copyright 2017 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CPMServiceTelephone : NSObject {
	NSString	*bin;
    NSString		*name;
	NSString		*areaCode;
	NSString		*prefix;
	NSString		*line;
	NSString		*type;
  //  NSString	*extension;
 //   NSString	*fullNumber;
}

@property (nonatomic, copy) NSString* bin;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *areaCode;
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *line;
@property (nonatomic, copy) NSString *type;
//@property (nonatomic, copy) NSString* extension;
//@property (nonatomic, copy) NSString* fullNumber;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary;
//- (NSDictionary*) dictionaryValue;


@end
