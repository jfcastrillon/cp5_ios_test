//
//  ResourceSearchResultCell.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/4/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "ResourceSearchResultCell.h"


@implementation ResourceSearchResultCell

@synthesize nameLabel;
@synthesize addressLabel;
@synthesize distanceLabel;
@synthesize activityIndicator;
@synthesize handicapImage;
@synthesize bedImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

- (void)dealloc {
	[nameLabel release];
	[addressLabel release];
	[activityIndicator release];
	[distanceLabel release];
	[handicapImage release];
	[bedImage release];
    [super dealloc];
}


@end
