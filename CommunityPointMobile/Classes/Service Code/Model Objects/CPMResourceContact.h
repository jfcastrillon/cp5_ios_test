//
//  CPMResourceContact.h
//  CommunityPointMobile
//
//  Created by Ben Carver on 6/22/17.
//  Copyright 2017 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CPMResourceContact : NSObject {
	NSString		*description; 
	NSString		*email;
	NSString		*name; 
	NSString		*phone; 
	NSString		*title;
    NSString        *websiteAddress;
}


@property (nonatomic, copy) NSString *description; 
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *name; 
@property (nonatomic, copy) NSString *phone; 
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *websiteAddress;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary;
//- (NSDictionary*) dictionaryValue;


@end
