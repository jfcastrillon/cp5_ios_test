//
//  HomeViewController.h
//  CommunityPointMobile
//
//  Created by Matthew Baker on 9/29/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView* tableView;
	UIButton* helpVideo;
	UIButton* website;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UIButton* helpVideo;
@property (nonatomic, retain) IBOutlet UIButton* website;

- (IBAction) videoButtonPressed: (id) sender;
- (IBAction) websiteButtonPressed: (id) sender;

@end
