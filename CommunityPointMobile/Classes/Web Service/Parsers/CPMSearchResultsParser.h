//
//  CPMResourceArrayParser.h
//  CommunityPointMobile
//
//  Handles parsing the result of a search request.
//
//  Created by John Cannon on 6/17/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONResponseParser.h"


@interface CPMSearchResultsParser : JSONResponseParser {

}

- (id) parseData:(NSData *)data;

@end
