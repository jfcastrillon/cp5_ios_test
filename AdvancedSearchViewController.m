//
//  AdvancedSearchViewController.m
//  CommunityPointMobile
//
//  Created by Matthew Baker on 9/22/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "AdvancedSearchViewController.h"


@implementation AdvancedSearchViewController
@synthesize tableView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
																			 style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
	self.title = @"Advanced Search";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" 
																			  style:UIBarButtonItemStylePlain target:self action:@selector(search:)];	

    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.tableView = nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
	[tableView reloadData];

	[super viewWillAppear:animated];
}

- (IBAction) cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) search:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[tableView release];

    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0 || section == 1 || section == 2) {
		return 3;
	} else {
		return 1;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    // Return a title or nil as appropriate for the section.
    if(section == 0) {
		title = @"Keywords";
    } else if (section == 3) {
		title = @"Volunteer Opportunities";
	} else if (section == 4) {
		title = @"Wishlists";
	}

    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 1) {
		UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 36)];
		v.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,0,150,36)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont boldSystemFontOfSize:17.0];
		label.textColor = [UIColor colorWithRed: 76/255.0 green: 86/255.0 blue: 108/255.0 alpha:1.0];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0, 1);
		[label setText:@"Physical Location"];

		[v addSubview:label];

		[label release];

		UIButton *help = [UIButton buttonWithType:UIButtonTypeInfoDark];
		[help addTarget:self action:@selector(locationHelp:) forControlEvents:UIControlEventTouchUpInside];
		[help setFrame:CGRectMake(265, -5, 50, 50)];

		[v addSubview:help];
		
		return v;
	} else if (section == 2) {
		UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 36)];
		v.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,0,150,36)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont boldSystemFontOfSize:17.0];
		label.textColor = [UIColor colorWithRed: 76/255.0 green: 86/255.0 blue: 108/255.0 alpha:1.0];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0, 1);		
		[label setText:@"Areas Served"];
		
		[v addSubview:label];
		
		[label release];
		
		UIButton *help = [UIButton buttonWithType:UIButtonTypeInfoDark];
		[help addTarget:self action:@selector(servedHelp:) forControlEvents:UIControlEventTouchUpInside];
		[help setFrame:CGRectMake(265, -5, 50, 50)];
		
		[v addSubview:help];
		
		return v;
	} else {
		return nil;
	}
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	static NSString *KeywordsAllCellIdentifier = @"KeywordsAllCellIdentifier";
	static NSString *KeywordsAnyCellIdentifier = @"KeywordsAnyCellIdentifier";
	static NSString *KeywordsNoneCellIdentifier = @"KeywordsNoneCellIdentifier";
	static NSString *LocationZipCellIdentifier = @"LocationZipCellIdentifier";
	static NSString *LocationCityCellIdentifier = @"LocationCityCellIdentifier";
	static NSString *LocationCountyCellIdentifier = @"LocationCountyCellIdentifier";
	static NSString *ServedZipCellIdentifier = @"ServedZipCellIdentifier";
	static NSString *ServedCityCellIdentifier = @"ServedCityCellIdentifier";
	static NSString *ServedCountyCellIdentifier = @"ServedCountyCellIdentifier";
	static NSString *VolunteerCellIdentifier = @"VolunteerCellIdentifier";
	static NSString *WishListCellIdentifier = @"WishListCellIdentifier";

	if (indexPath.section == 0) {
		NSUInteger row = [indexPath row];
		
		if (row == 0){
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KeywordsAllCellIdentifier];
			if(cell == nil){
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:KeywordsAllCellIdentifier] autorelease];
				cell.detailTextLabel.text = @"All";
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, 280, 31)];
				txtField.delegate = self;
				[txtField setReturnKeyType:UIReturnKeyDone];
				txtField.placeholder = @"All of these words";
				txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
				[cell addSubview:txtField];
				[txtField release];
			}
			
			return cell;
		} else if (row == 1){
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KeywordsAnyCellIdentifier];
			if(cell == nil){
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:KeywordsAnyCellIdentifier] autorelease];
				cell.detailTextLabel.text = @"Any";
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, 280, 31)];
				txtField.delegate = self;
				[txtField setReturnKeyType:UIReturnKeyDone];
				txtField.placeholder = @"Any of these words";
				txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
				[cell addSubview:txtField];
				[txtField release];
			}
			
			return cell;
		} else if (row == 2){
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KeywordsNoneCellIdentifier];
			if(cell == nil){
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:KeywordsNoneCellIdentifier] autorelease];
				cell.detailTextLabel.text = @"None";
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, 280, 31)];
				txtField.delegate = self;
				[txtField setReturnKeyType:UIReturnKeyDone];
				txtField.placeholder = @"None of these words";
				txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
				[cell addSubview:txtField];
				[txtField release];
			}
			
			return cell;
		}
	} else if (indexPath.section == 1) {
		NSUInteger row = [indexPath row];

		if (row == 0){
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LocationZipCellIdentifier];
			if(cell == nil){
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LocationZipCellIdentifier] autorelease];
				cell.detailTextLabel.text = @"ZIP";
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, 280, 31)];
				txtField.delegate = self;
				[txtField setReturnKeyType:UIReturnKeyDone];
				txtField.placeholder = @"";
				txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
				[cell addSubview:txtField];
				[txtField release];
			}
			
			return cell;
		} else if (row == 1){
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LocationCityCellIdentifier];
			if(cell == nil){
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LocationCityCellIdentifier] autorelease];
				cell.detailTextLabel.text = @"City";
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, 280, 31)];
				txtField.delegate = self;
				[txtField setReturnKeyType:UIReturnKeyDone];
				txtField.placeholder = @"";
				txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
				[cell addSubview:txtField];
				[txtField release];
			}
			
			return cell;
		} else if (row == 2){
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LocationCountyCellIdentifier];
			if(cell == nil){
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LocationCountyCellIdentifier] autorelease];
				cell.detailTextLabel.text = @"County";
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, 280, 31)];
				txtField.delegate = self;
				[txtField setReturnKeyType:UIReturnKeyDone];
				txtField.placeholder = @"";
				txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
				[cell addSubview:txtField];
				[txtField release];
			}
			
			return cell;
		}
	} else if (indexPath.section == 2) {
		NSUInteger row = [indexPath row];
		
		if (row == 0){
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ServedZipCellIdentifier];
			if(cell == nil){
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ServedZipCellIdentifier] autorelease];
				cell.detailTextLabel.text = @"ZIP";
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, 280, 31)];
				txtField.delegate = self;
				[txtField setReturnKeyType:UIReturnKeyDone];
				txtField.placeholder = @"";
				txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
				[cell addSubview:txtField];
				[txtField release];
			}
			
			return cell;
		} else if (row == 1){
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ServedCityCellIdentifier];
			if(cell == nil){
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ServedCityCellIdentifier] autorelease];
				cell.detailTextLabel.text = @"City";
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, 280, 31)];
				txtField.delegate = self;
				[txtField setReturnKeyType:UIReturnKeyDone];
				txtField.placeholder = @"";
				txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
				[cell addSubview:txtField];
				[txtField release];
			}
			
			return cell;
		} else if (row == 2){
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ServedCountyCellIdentifier];
			if(cell == nil){
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ServedCountyCellIdentifier] autorelease];
				cell.detailTextLabel.text = @"County";
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, 280, 31)];
				txtField.delegate = self;
				[txtField setReturnKeyType:UIReturnKeyDone];
				txtField.placeholder = @"";
				txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
				[cell addSubview:txtField];
				[txtField release];
			}
			
			return cell;
		}
	} else if (indexPath.section == 3) {
		NSUInteger row = [indexPath row];
		
		if (row == 0) {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VolunteerCellIdentifier];
			if(cell == nil){
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:VolunteerCellIdentifier] autorelease];
				cell.detailTextLabel.text = @"Keywords";
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+100, cell.frame.origin.y+11, 280, 31)];
				txtField.delegate = self;
				[txtField setReturnKeyType:UIReturnKeyDone];
				txtField.placeholder = @"";
				txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
				[cell addSubview:txtField];
				[txtField release];
			}
			
			return cell;
		}
	} else if (indexPath.section == 4) {
		NSUInteger row = [indexPath row];
		
		if (row == 0) {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WishListCellIdentifier];
			if(cell == nil){
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:WishListCellIdentifier] autorelease];
				cell.detailTextLabel.text = @"Keywords";
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+100, cell.frame.origin.y+11, 280, 31)];
				txtField.delegate = self;
				[txtField setReturnKeyType:UIReturnKeyDone];
				txtField.placeholder = @"";
				txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
				[cell addSubview:txtField];
				[txtField release];
			}
			
			return cell;
		}
	}
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

- (void)locationHelp:(id)sender {
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Physical Location" message:@"Find Resources based on the physical location of each site that offers services." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)servedHelp:(id)sender {
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Areas Served" message:@"Find resources that serve a specific geographic region, which may vary from a resource's physical location. Searching by \"Areas Served\" will return resources that serve at least part of the ZIP, City, or County used in the search. Resources may not serve the ENTIRE area searched." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
}

@end
