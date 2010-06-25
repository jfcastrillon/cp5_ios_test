//
//  ResourceSearchResultCell.h
//  CommunityPointMobile
//
//  Created by John Cannon on 4/4/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResourceSearchResultCell : UITableViewCell {
	UILabel	*nameLabel;
	UILabel *addressLabel;
	UILabel *distanceLabel;
	UIActivityIndicatorView *activityIndicator;
	UIImageView *bedImage;
	UIImageView *handicapImage;
}

@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UILabel* addressLabel;
@property (nonatomic, retain) IBOutlet UILabel* distanceLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (nonatomic, retain) IBOutlet UIImageView* bedImage;
@property (nonatomic, retain) IBOutlet UIImageView* handicapImage;

@end
