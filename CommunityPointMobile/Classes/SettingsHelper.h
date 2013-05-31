//
//  SettingsHelper.h
//  CommunityPointMobile
//
//  Created by Matthew Baker on 10/19/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingsHelper : NSObject {
	NSMutableDictionary* settings;
}

@property (nonatomic, readonly) NSMutableDictionary* settings;

- (id) init;

+ (SettingsHelper*) sharedInstance;

@end
