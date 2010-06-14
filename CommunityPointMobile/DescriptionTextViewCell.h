//
//  DescriptionTextViewCell.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/11/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DescriptionTextViewCell : UITableViewCell {
	UITextView *textView;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;

+ (DescriptionTextViewCell*) createFromNib;

@end
