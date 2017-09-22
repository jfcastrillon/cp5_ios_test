//
//  SettingsHelper.m
//  CommunityPointMobile
//
//  Created by Matthew Baker on 10/19/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "SettingsHelper.h"


@implementation SettingsHelper

@synthesize settings;

- (id) init {
	if([super init] == nil) return nil;

	NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
	[settings release];
    settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

	return self;
}

- (void) dealloc {
	[settings release], settings = nil;

	[super dealloc];
}

// Below implements the singleton pattern for this class (from examples online)

static SettingsHelper* sharedHelperInstance = nil;

+ (SettingsHelper*) sharedInstance {
	@synchronized(self){
		if (sharedHelperInstance == nil) {
			sharedHelperInstance = [[self alloc] init];
		}
	}
	return sharedHelperInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedHelperInstance == nil) {
            sharedHelperInstance = [super allocWithZone:zone];
            return sharedHelperInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //never let this be released;
}

- (oneway void)release {
    //prevent release
}

- (id)autorelease {
    return self;
}

@end
