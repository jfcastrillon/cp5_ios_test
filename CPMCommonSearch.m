//
//  CPMCommonSearch.m
//  CommunityPointMobile
//
//  Created by John Cannon on 10/21/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "CPMCommonSearch.h"


@implementation CPMCommonSearch

@synthesize name, query, sort;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
	if([super init] == nil) return nil;
	self.name = nullFix([dictionary objectForKey: @"name"]);
	self.query = nullFix([dictionary objectForKey: @"query"]);
	self.sort = [dictionary objectForKey: @"sort"];
	
	return self;
}

- (NSDictionary*) queryParameters {

	NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
	NSArray* parts = [self.query componentsSeparatedByString:@"&"];
	
	for(NSString* part in parts){
		NSArray* pair = [part componentsSeparatedByString:@"="];
		
		NSString* key = [pair objectAtIndex:0];
		NSString* value = [pair objectAtIndex:1];
		
		[result setObject:value forKey:key];
	}
	
	return [result autorelease];
}


- (void) dealloc {
	self.name = nil;
	self.query = nil;
	self.sort = nil;
	[super dealloc];
}

@end
