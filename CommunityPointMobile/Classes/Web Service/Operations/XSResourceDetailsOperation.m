//
//  XSResourceDetailsOperation.m
//  CommunityPointMobile
//
//  Created by John Cannon on 6/18/10.
//  Copyright (c) 2010 Bowman Systems, LLC. All rights reserved.
//

#import "XSResourceDetailsOperation.h"
#import "XSResourceSearchOperation.h"
#import "CPMResourceDetailParser.h"
#import "XServicesHelper.h"


@implementation XSResourceDetailsOperation

- (id) initWithResourceId: (NSUInteger) resourceId andSearchHistoryId: (NSUInteger) searchHistoryId {
    // Setup method call paramters
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue: [[NSDecimalNumber numberWithUnsignedInt: resourceId] stringValue] forKey:@"id"];
    [params setValue: @"external" forKey:@"source"];
    [params setValue: searchHistoryId  forKey:@"search_history_id"];
      
    // Parser for the response data
    id parser = [[CPMResourceDetailParser alloc] init];
    
    // Let the base class handle the rest
    [super initWithAction: @"resources.pullWithServiceDetails" andParameters: params andParser: parser];
    
    [params release];
    [parser release];
    
    return self;
}

@end
