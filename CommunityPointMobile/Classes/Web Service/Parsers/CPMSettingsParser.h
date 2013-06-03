//
//  CPMSettingsParser.h
//  CommunityPointMobile
//
//  Created by Matthew Baker on 5/22/13.
//  Copyright (c) 2013 Bowman Systems, LLC. All rights reserved.
//

#import "JSONResponseParser.h"
#import "CPMSettings.h"

@interface CPMSettingsParser : JSONResponseParser {
    
}

- (id) parseData:(NSData *)data;

@end
