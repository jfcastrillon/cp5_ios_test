//
//  CPMResourceContact.m
//  CommunityPointMobile
//
//  Created by Ben Carver on 6/22/17.
//  Copyright 2017 Bowman Systems, LLC. All rights reserved.
//


#import "CPMServiceTelephone.h"
#import "Util.h"

@implementation CPMServiceTelephone
@synthesize bin;
@synthesize name;
@synthesize areaCode;
@synthesize prefix;
@synthesize line;
@synthesize type;
//@synthesize extension;

- (id) initFromJsonDictionary: (NSDictionary*) dictionary {
    if([super init] == nil) return nil;
    self.name = nullFix([dictionary objectForKey: @"name"]);
    self.areaCode = nullFix([dictionary objectForKey: @"areacode"]);
    self.prefix = nullFix([dictionary objectForKey: @"prefix"]);
    self.line = nullFix([dictionary objectForKey: @"line"]);
//    self.extension = nullFix([dictionary objectForKey: @"ext"]);
    //self.fullNumber = nullFix([dictionary objectForKey:@"number"]);
    self.type = nullFix([dictionary objectForKey:@"type"]);
    
    return self;
}

- (void) dealloc {
      self.name = nil;
    self.areaCode = nil;
    self.prefix = nil;
    self.line = nil;
//    self.extension = nil;
    //self.fullNumber = nil;
    self.type = nil;
    [super dealloc];
}

@end

