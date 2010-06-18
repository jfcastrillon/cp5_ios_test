//
//  XSResourceSearchOperation.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/17/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XServicesRequestOperation.h"

@interface XSResourceSearchOperation : XServicesRequestOperation {
	NSString *_query;
	
}

- (id) initWithQuery: (NSString*) query andMaxCount: (NSUInteger) maxCount;
- (id) initWithQuery: (NSString*) query andMaxCount: (NSUInteger) maxCount andOffset: (NSUInteger) offset andSearchHistoryId: (NSUInteger) searchId;

@end
