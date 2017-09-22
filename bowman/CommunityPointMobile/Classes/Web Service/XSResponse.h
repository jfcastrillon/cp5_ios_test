//
//  XSResponse.h
//  CommunityPointMobile
//
//  Created by John Cannon on 6/18/10.
//  Copyright (c) 2010 Bowman Systems, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XSResponse : NSObject {
	NSString *tag;
	id result;
}

@property (nonatomic, retain) NSString *tag;
@property (nonatomic, retain) id result;

@end
