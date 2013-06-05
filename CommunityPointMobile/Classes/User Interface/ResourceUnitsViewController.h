//
//  ResourceUnitsViewController.h
//  CommunityPointMobile
//
//  Created by Matthew Baker on 5/31/13.
//  Copyright (c) 2013 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPMResourceDetail.h"

@interface ResourceUnitsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    CPMResourceDetail *displayedResource;
    UITableView* tableView;
}

@property (nonatomic, retain) CPMResourceDetail *displayedResource;
@property (nonatomic, retain) IBOutlet UITableView* tableView;

- (void) updateDisplay;

@end
