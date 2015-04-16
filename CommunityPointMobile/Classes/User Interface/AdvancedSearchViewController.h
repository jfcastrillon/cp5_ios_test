//
//  AdvancedSearchViewController.h
//  CommunityPointMobile
//
//  Created by Matthew Baker on 9/22/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XServicesHelper.h"
#import "SettingsHelper.h"

@protocol AdvancedSearchViewControllerDelegate <NSObject>

- (void) setSearchBarText: (NSString*) text;

@end

@interface AdvancedSearchViewController : UITableViewController <UITextFieldDelegate> {
    SettingsHelper* settingsHelper;
}

- (UITextField*) textFieldForSection:(NSUInteger)section row:(NSUInteger)row;
- (UISegmentedControl*) segmentedControlForSection:(NSUInteger)section row:(NSUInteger)row;
- (void) createCell:(NSUInteger)section row:(NSUInteger)row;

@property (nonatomic, retain) id<AdvancedSearchViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableDictionary *cellDictionary;

@end
