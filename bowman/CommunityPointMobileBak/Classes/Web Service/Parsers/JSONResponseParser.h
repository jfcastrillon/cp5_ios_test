//
//  JSONResponseParser.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/17/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseParser.h"


@interface JSONResponseParser : NSObject <ResponseParser> {

}

- (id) parseData:(NSData *)data;

@end
