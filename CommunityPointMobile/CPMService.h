//
//  CPMService.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/21/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CPMService : NSObject {
	NSString	*code;
	NSString	*name;
}

@property (nonatomic, copy) NSString* code;
@property (nonatomic, copy) NSString* name;

@end
