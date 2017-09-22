//
//  Util.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/14/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPMResourceDetail.h"

id nullFix(id value);

NSString* buildEmail(CPMResourceDetail* resource);
NSString* buildSMS(CPMResourceDetail* resource);