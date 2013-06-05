//
//  CPMUnitInfo.h
//  CommunityPointMobile
//
//  Created by Matthew Baker on 5/31/13.
//  Copyright (c) 2013 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPMUnitInfo : NSObject {
    NSString *unitListName;
    NSString *unitListType;
    NSDecimalNumber *totalUnits;
    NSDecimalNumber *availableUnits;
    NSDecimalNumber *usedUnits;
}

@property (nonatomic, copy) NSString* unitListName;
@property (nonatomic, copy) NSString* unitListType;
@property (nonatomic, copy) NSDecimalNumber* totalUnits;
@property (nonatomic, copy) NSDecimalNumber* availableUnits;
@property (nonatomic, copy) NSDecimalNumber* usedUnits;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary;

@end
