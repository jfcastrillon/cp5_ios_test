//
//  ResourceUnitsViewController.m
//  CommunityPointMobile
//
//  Created by Matthew Baker on 5/31/13.
//  Copyright (c) 2013 Bowman Systems, LLC. All rights reserved.
//

#import "ResourceUnitsViewController.h"

@implementation ResourceUnitsViewController

@synthesize tableView;

@dynamic displayedResource;

- (CPMResourceDetail*) displayedResource {
	return displayedResource;
}

- (void) setDisplayedResource:(CPMResourceDetail*) newResource {
	if (newResource != displayedResource) {
		[displayedResource release];
		displayedResource = newResource;

		[displayedResource retain];
		[self updateDisplay];
	}
}

- (void) updateDisplay {
	if (displayedResource != nil) {
        [self.tableView reloadData];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    if (displayedResource != nil) {
		[self updateDisplay];
	}
    
    self.navigationItem.title = @"Shelter Information";

    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
	if (displayedResource != nil) {
		[tableView reloadData];
	}
	
	[super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.displayedResource = nil;
	self.tableView = nil;
	
	[super viewDidUnload];
}

- (void)dealloc {
	[displayedResource release];
	[tableView release];
    [super dealloc];
}

//Table data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if(displayedResource == nil) {
		return 0;
	} else {
        return [[displayedResource unitInfos] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[displayedResource unitInfos] objectAtIndex:section] unitListName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell*)tableView:(UITableView*)_tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	static NSString *UnitCellIdentifier = @"UnitCellIdentifier";

	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:UnitCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:UnitCellIdentifier] autorelease];
    }
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.adjustsLetterSpacingToFitWidth = YES;
    cell.detailTextLabel.numberOfLines = 1;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    if (row == 0) {
        cell.textLabel.text = @"shelter type";
        cell.detailTextLabel.text = [[[displayedResource unitInfos] objectAtIndex:section] unitListType];
    } else if (row == 1) {
        cell.textLabel.text = @"available";
        cell.detailTextLabel.text = [[[[[displayedResource unitInfos] objectAtIndex:section] availableUnits] stringValue] stringByAppendingString:@" Units"];
    } else if (row == 2) {
        cell.textLabel.text = @"total";
        cell.detailTextLabel.text = [[[[[displayedResource unitInfos] objectAtIndex:section] totalUnits] stringValue] stringByAppendingString:@" Units"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (void) tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
