//
//  CPMSettings.h
//  CommunityPointMobile
//
//  Created by Matthew Baker on 5/22/13.
//  Copyright (c) 2013 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPMSettings : NSObject {
    NSDictionary	*settings;
}

@property (nonatomic, copy) NSDictionary *settings;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary;

@end
