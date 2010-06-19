//
//  CPMResourceDetailParser.h
//  CommunityPointMobile
//
//  Handles parsing the full resource details retrieved from XServices.
//
//  Created by John Cannon on 6/17/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONResponseParser.h"

@interface CPMResourceDetailParser : JSONResponseParser {

}

- (id) parseData:(NSData *)data;

@end
