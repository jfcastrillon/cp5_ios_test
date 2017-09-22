//
//  ResponseParser.h
//  CommunityPointMobile
//
//  This is the protocol used by all classes that are intended to parse 
//  web service response data. 
//
//  Created by John Cannon on 5/7/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResponseParser

// This method should parse the raw response data into an actual model object.
- (id) parseData:(NSData*) data;

@end
