//
//  SettingsHelper.h
//  CommunityPointMobile
//
//  Created by Matthew Baker on 10/19/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingsHelper : NSObject {
	NSDictionary* settings;
}

@property (nonatomic, readonly) NSDictionary* settings;

- (id) init;

+ (SettingsHelper*) sharedInstance;

@end
