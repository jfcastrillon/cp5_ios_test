//
//  XSResourceDetailsOperation.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XServicesRequestOperation.h"

@interface XSResourceDetailsOperation : XServicesRequestOperation {
}

-(id) initWithResourceId: (NSUInteger) resourceId;

@end
