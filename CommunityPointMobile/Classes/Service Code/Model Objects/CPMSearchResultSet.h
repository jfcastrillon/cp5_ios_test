//
//  CPMSearchResultSet.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/17/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CPMSearchResultSet : NSObject {
	NSDecimalNumber *searchHistoryId;
	NSDecimalNumber *offset;
	NSDecimalNumber *count;
	NSDecimalNumber *totalCount;
	NSNumber *refLatitude;
	NSNumber *refLongitude;
	NSArray *results;
	
}

@property (nonatomic, copy) NSDecimalNumber *searchHistoryId;
@property (nonatomic, copy) NSDecimalNumber *offset;
@property (nonatomic, copy) NSDecimalNumber *count;
@property (nonatomic, copy) NSDecimalNumber *totalCount;
@property (nonatomic, copy) NSNumber *refLatitude;
@property (nonatomic, copy) NSNumber *refLongitude;
@property (nonatomic, copy) NSArray *results;

@end
