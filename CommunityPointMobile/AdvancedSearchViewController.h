//
//  AdvancedSearchViewController.h
//  CommunityPointMobile
//
//  Created by Matthew Baker on 9/22/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XServicesHelper.h"

@interface AdvancedSearchViewController : UITableViewController {
	UITableView* tableView;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;

- (UITextField*) textFieldForSection:(NSUInteger)section row:(NSUInteger)row;

@end
