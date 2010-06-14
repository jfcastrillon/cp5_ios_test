//
//  DescriptionTextViewCell.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/11/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "DescriptionTextViewCell.h"


@implementation DescriptionTextViewCell

@synthesize textView;

+ (DescriptionTextViewCell*) createFromNib { 
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"DescriptionTextViewCell" owner:self options:nil]; 
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator]; 
    DescriptionTextViewCell* tCell = nil; 
    NSObject* nibItem = nil; 
    while ( (nibItem = [nibEnumerator nextObject]) != nil) { 
        if ( [nibItem isKindOfClass: [DescriptionTextViewCell class]]) { 
            tCell = (DescriptionTextViewCell*) nibItem; 
            break;
        } 
    } 
    return tCell; 
} 


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[textView release];
    [super dealloc];
}


@end
