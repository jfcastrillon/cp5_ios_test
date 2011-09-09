//
//  CPMCommonSearchParser.h
//  CommunityPointMobile
//
//  Created by John Cannon on 10/21/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONResponseParser.h"
#import "CPMCommonSearch.h"

@interface CPMCommonSearchParser : JSONResponseParser {

}

- (id) parseData:(NSData *)data;

@end
