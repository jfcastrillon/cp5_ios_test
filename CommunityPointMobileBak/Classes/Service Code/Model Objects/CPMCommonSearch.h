//
//  CPMCommonSearch.h
//  CommunityPointMobile
//
//  Created by John Cannon on 10/21/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CPMCommonSearch : NSObject {
}

@property (nonatomic,copy) NSDecimalNumber* commonId;
@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* query;
@property (nonatomic,copy) NSDecimalNumber* sort;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary;
- (NSDictionary*) queryParameters;

@end
