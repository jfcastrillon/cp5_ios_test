//
//  AdvancedSearchViewController.m
//  CommunityPointMobile
//
//  Created by Matthew Baker on 9/22/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "AdvancedSearchViewController.h"


@implementation AdvancedSearchViewController

@synthesize delegate;
@synthesize cellDictionary;

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
    cellDictionary = [[NSMutableDictionary alloc] init];
    [self createCell:0 row:0];
    [self createCell:0 row:1];
    [self createCell:0 row:2];
    [self createCell:1 row:0];
    [self createCell:1 row:1];
    [self createCell:1 row:2];
    [self createCell:2 row:0];
    [self createCell:2 row:1];
    [self createCell:2 row:2];
    [self createCell:3 row:0];
    [self createCell:4 row:0];
    [self createCell:5 row:0];
    
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

- (void) createCell:(NSUInteger)section row:(NSUInteger)row {
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
    static NSString *ServiceCodesCellIdentifier = @"ServiceCodesCellIdentifier";
    
	UITableViewCell *cell = nil;
	if (section == 0) {
		if (row == 0) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:KeywordsAllCellIdentifier];
            cell.detailTextLabel.text = @"All";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-86, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            txtField.placeholder = @"All of these words";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:txtField];
            [txtField release];
        } else if (row == 1) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:KeywordsAnyCellIdentifier];
            cell.detailTextLabel.text = @"Any";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-86, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            txtField.placeholder = @"Any of these words";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:txtField];
            [txtField release];
        } else if (row == 2) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:KeywordsNoneCellIdentifier];
            cell.detailTextLabel.text = @"None";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-86, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            txtField.placeholder = @"None of these words";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:txtField];
            [txtField release];
		}
	} else if (section == 1) {
		if (row == 0) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LocationZipCellIdentifier];
            cell.detailTextLabel.text = @"ZIP";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-86, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:txtField];
            [txtField release];
        } else if (row == 1) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LocationCityCellIdentifier];
            cell.detailTextLabel.text = @"City";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-86, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:txtField];
            [txtField release];
        } else if (row == 2) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LocationCountyCellIdentifier];
            cell.detailTextLabel.text = @"County";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-86, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:txtField];
            [txtField release];
		}
	} else if (section == 2) {
		if (row == 0) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ServedZipCellIdentifier];
            cell.detailTextLabel.text = @"ZIP";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-86, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:txtField];
            [txtField release];
        } else if (row == 1) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ServedCityCellIdentifier];
            cell.detailTextLabel.text = @"City";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-86, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:txtField];
        } else if (row == 2) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ServedCountyCellIdentifier];
            cell.detailTextLabel.text = @"County";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-86, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:txtField];
            [txtField release];
		}
	} else if (section == 3) {
		if (row == 0) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:VolunteerCellIdentifier];
            cell.detailTextLabel.text = @"Keywords";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+100, cell.frame.origin.y+11, cell.frame.size.width-106, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:txtField];
            [txtField release];
		}
	} else if (section == 4) {
		if (row == 0) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:WishListCellIdentifier];
            cell.detailTextLabel.text = @"Keywords";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+100, cell.frame.origin.y+11, cell.frame.size.width-106, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:txtField];
            
            [txtField release];
		}
	} else if (section == 5) {
		if (row == 0) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ServiceCodesCellIdentifier];
            cell.detailTextLabel.text = @"Service Codes";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+132, cell.frame.origin.y+11, cell.frame.size.width-139, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:txtField];
            [txtField release];
		}
	}
    
    NSString *cellId = [NSString stringWithFormat:@"id_%d_%d", section, row];
    [cellDictionary setObject:cell forKey:cellId];
    
    [cell release];
}

- (void) viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
    
	NSDictionary* previousParameters = [[XServicesHelper sharedInstance] lastQueryParams];
	if(previousParameters != nil){
		[self textFieldForSection:0 row:0].text = [previousParameters objectForKey:kXSQueryKeywordsAll];
		[self textFieldForSection:0 row:1].text = [previousParameters objectForKey:kXSQueryKeywordsAny];
		[self textFieldForSection:0 row:2].text = [previousParameters objectForKey:kXSQueryKeywordsNone];
		
		[self textFieldForSection:1 row:0].text = [previousParameters objectForKey:kXSQueryPhysicalLocationZIP];
		[self textFieldForSection:1 row:1].text = [previousParameters objectForKey:kXSQueryPhysicalLocationCity];
		[self textFieldForSection:1 row:2].text = [previousParameters objectForKey:kXSQueryPhysicalLocationCounty];
        
		[self textFieldForSection:2 row:0].text = [previousParameters objectForKey:kXSQueryGeoServedZIP];
		[self textFieldForSection:2 row:1].text = [previousParameters objectForKey:kXSQueryGeoServedCity];
		[self textFieldForSection:2 row:2].text = [previousParameters objectForKey:kXSQueryGeoServedCounty];
		
		[self textFieldForSection:3 row:0].text = [previousParameters objectForKey:kXSQueryVolunteerKeywords];
        
		[self textFieldForSection:4 row:0].text = [previousParameters objectForKey:kXSQueryWishlistKeywords];
        
        [self textFieldForSection:5 row:0].text = [previousParameters objectForKey:kXSQueryServiceCodes];
    }
	
	[super viewWillAppear:animated];
}

- (UITextField*) textFieldForSection:(NSUInteger)section row:(NSUInteger)row {
    NSString *cellId = [NSString stringWithFormat:@"id_%d_%d", section, row];
    UITableViewCell* cell = [cellDictionary objectForKey:cellId];

	for (UIView* view in [cell subviews]) {
		if([view isKindOfClass:[UITextField class]])
			return (UITextField*) view;
	}
	
	// Should never happen...
	return nil;
}

- (IBAction) cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) search:(id)sender {
	
	NSString* all = [[self textFieldForSection:0 row:0] text];
	NSString* any = [[self textFieldForSection:0 row:1] text];
	NSString* none = [[self textFieldForSection:0 row:2] text];
	
	NSString* physicalZip = [[self textFieldForSection:1 row:0] text];
	NSString* physicalCity = [[self textFieldForSection:1 row:1] text];
	NSString* physicalCounty = [[self textFieldForSection:1 row:2] text];
    
	NSString* geoZip = [[self textFieldForSection:2 row:0] text];
	NSString* geoCity = [[self textFieldForSection:2 row:1] text];
	NSString* geoCounty = [[self textFieldForSection:2 row:2] text];
	
	NSString* volunteer = [[self textFieldForSection:3 row:0] text];
	NSString* wishlist = [[self textFieldForSection:4 row:0] text];
    
    NSString* codes = [[self textFieldForSection:5 row:0] text];
	
	NSMutableDictionary* params;
    if ([[XServicesHelper sharedInstance] lastQueryParams]) {
        params = [[[XServicesHelper sharedInstance] lastQueryParams] mutableCopy];
    } else {
        params = [NSMutableDictionary dictionary];
    }
    [params removeObjectForKey:kXSQueryNatural];
    
	//Required parameters
	[params setObject:[NSDecimalNumber numberWithInt:10] forKey:kXSQueryMaxCount];
	[params setObject:[NSDecimalNumber numberWithInt:0] forKey:kXSQueryOffset];
	[params setObject:[NSDecimalNumber numberWithInt:-1] forKey:kXSQuerySearchHistoryId];
	
	if(all)
		[params setObject:all forKey:kXSQueryKeywordsAll];
	if(any)
		[params setObject:any forKey:kXSQueryKeywordsAny];
	if(none)
		[params setObject:none forKey:kXSQueryKeywordsNone];
	
	if(physicalZip)
		[params setObject:physicalZip forKey:kXSQueryPhysicalLocationZIP];
	if(physicalCity)
		[params setObject:physicalCity forKey:kXSQueryPhysicalLocationCity];
	if(physicalCounty)
		[params setObject:physicalCounty forKey:kXSQueryPhysicalLocationCounty];
	
	if(geoZip)
		[params setObject:geoZip forKey:kXSQueryGeoServedZIP];
	if(geoCity)
		[params setObject:geoCity forKey:kXSQueryGeoServedCity];
	if(geoCounty)
		[params setObject:geoCounty forKey:kXSQueryGeoServedCounty];
	
	if(volunteer)
		[params setObject:volunteer forKey:kXSQueryVolunteerKeywords];
	if(wishlist)
		[params setObject:wishlist forKey:kXSQueryWishlistKeywords];
    
    if(codes)
        [params setObject:codes forKey:kXSQueryServiceCodes];
	
	[[XServicesHelper sharedInstance] searchResourcesWithQueryParams:params];
	[self.delegate setSearchBarText:@"(Advanced Search)"];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [cellDictionary release];
	[delegate release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 6;
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
	} else if (section == 5) {
        title = @"Services";
    }
    
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 1) {
		UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 36)] autorelease];
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
		UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 36)] autorelease];
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
    NSString *cellId = [NSString stringWithFormat:@"id_%d_%d", indexPath.section, indexPath.row];
    UITableViewCell* cell = [cellDictionary objectForKey:cellId];
	
	return cell;
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
