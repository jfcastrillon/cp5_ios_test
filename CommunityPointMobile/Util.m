//
//  Util.c
//  CommunityPointMobile
//
//  Created by John Cannon on 6/14/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "Util.h"

id nullFix(id value) {
	if((NSNull*)value == [NSNull null])
		return nil;
	else
		return value;
}