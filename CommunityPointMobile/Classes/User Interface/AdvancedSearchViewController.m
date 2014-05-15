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

int keywordsSection = 50, physicalSection = 50, areasSection = 50, volunteerSection = 50, wishlistSection = 50, sheltersSection = 50, serviceCodesSection = 50;
int allRow = 50, anyRow = 50, noneRow = 50, physicalZipRow = 50, physicalCityRow = 50, physicalCountyRow = 50, areasZipRow = 50, areasCityRow = 50, areasCountyRow = 50;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    settingsHelper = [SettingsHelper sharedInstance];
    
    cellDictionary = [[NSMutableDictionary alloc] init];
    int section = 0, row = 0;
    
    // Keywords All
    if ([[[settingsHelper settings] valueForKey:@"show_refine_keywords_all"] boolValue] == YES) {
        keywordsSection = section; allRow = row;
        [self createCell:section row:row];
        row++;
    }
    // Keywords Any
    if ([[[settingsHelper settings] valueForKey:@"show_refine_keywords_any"] boolValue] == YES) {
        keywordsSection = section; anyRow = row;
        [self createCell:section row:row];
        row++;
    }
    // Keywords None
    if ([[[settingsHelper settings] valueForKey:@"show_refine_keywords_none"] boolValue] == YES) {
        keywordsSection = section; noneRow = row;
        [self createCell:section row:row];
        row++;
    }

    if (row > 0) {
        section++;
    }
    row = 0;
    // Physical Location ZIP
    if ([[[settingsHelper settings] valueForKey:@"show_refine_location_zip"] boolValue] == YES) {
        physicalSection = section; physicalZipRow = row;
        [self createCell:section row:row];
        row++;
    }
    // Physical Location City
    if ([[[settingsHelper settings] valueForKey:@"show_refine_location_city"] boolValue] == YES) {
        physicalSection = section; physicalCityRow = row;
        [self createCell:section row:row];
        row++;
    }
    // Physical Location County
    if ([[[settingsHelper settings] valueForKey:@"show_refine_location_county"] boolValue] == YES) {
        physicalSection = section; physicalCountyRow = row;
        [self createCell:section row:row];
        row++;
    }

    if (row > 0) {
        section++;
    }
    row = 0;
    // Areas Served ZIP
    if ([[[settingsHelper settings] valueForKey:@"show_refine_area_zip"] boolValue] == YES) {
        areasSection = section; areasZipRow = row;
        [self createCell:section row:row];
        row++;
    }
    // Areas Served City
    if ([[[settingsHelper settings] valueForKey:@"show_refine_area_city"] boolValue] == YES) {
        areasSection = section; areasCityRow = row;
        [self createCell:section row:row];
        row++;
    }
    // Areas Served County
    if ([[[settingsHelper settings] valueForKey:@"show_refine_area_county"] boolValue] == YES) {
        areasSection = section; areasCountyRow = row;
        [self createCell:section row:row];
        row++;
    }

    if (row > 0) {
        section++;
    }
    row = 0;
    // Volunteer Opportunities
    if ([[[settingsHelper settings] valueForKey:@"show_refine_volunteer_op"] boolValue] == YES) {
        volunteerSection = section;
        [self createCell:section row:row];
        row++;
    }
    
    if (row > 0) {
        section++;
    }
    row = 0;
    // Wishlists
    if ([[[settingsHelper settings] valueForKey:@"show_refine_wishlist"] boolValue] == YES) {
        wishlistSection = section;
        [self createCell:section row:row];
        row++;
    }
    
    if (row > 0) {
        section++;
    }
    row = 0;
    // Shelters
    if ([[[settingsHelper settings] valueForKey:@"show_refine_shelters"] boolValue] == YES) {
        sheltersSection = section;
        [self createCell:section row:row];
        row++;
    }
    
    if (row > 0) {
        section++;
    }
    row = 0;
    // Services
    if ([[[settingsHelper settings] valueForKey:@"show_refine_services"] boolValue] == YES) {
        serviceCodesSection = section;
        [self createCell:section row:row];
        row++;
    }

	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
																			 style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
	self.title = @"Advanced Search";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" 
																			  style:UIBarButtonItemStylePlain target:self action:@selector(search:)];	
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.tableView = nil;
	
    [super viewDidUnload];
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
    static NSString *SheltersCellIdentifier = @"SheltersCellIdentifier";
    static NSString *ServiceCodesCellIdentifier = @"ServiceCodesCellIdentifier";
    
	UITableViewCell *cell = nil;
	if (section == keywordsSection) {
		if (row == allRow) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:KeywordsAllCellIdentifier];
            cell.detailTextLabel.text = @"All";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-100, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            txtField.placeholder = @"All of these words";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:txtField];
            [txtField release];
        } else if (row == anyRow) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:KeywordsAnyCellIdentifier];
            cell.detailTextLabel.text = @"Any";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-100, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            txtField.placeholder = @"Any of these words";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:txtField];
            [txtField release];
        } else if (row == noneRow) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:KeywordsNoneCellIdentifier];
            cell.detailTextLabel.text = @"None";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-100, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            txtField.placeholder = @"None of these words";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:txtField];
            [txtField release];
		}
	} else if (section == physicalSection) {
		if (row == physicalZipRow) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LocationZipCellIdentifier];
            cell.detailTextLabel.text = @"ZIP";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-100, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:txtField];
            [txtField release];
        } else if (row == physicalCityRow) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LocationCityCellIdentifier];
            cell.detailTextLabel.text = @"City";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-100, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:txtField];
            [txtField release];
        } else if (row == physicalCountyRow) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LocationCountyCellIdentifier];
            cell.detailTextLabel.text = @"County";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-100, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:txtField];
            [txtField release];
		}
	} else if (section == areasSection) {
		if (row == areasZipRow) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ServedZipCellIdentifier];
            cell.detailTextLabel.text = @"ZIP";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-100, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:txtField];
            [txtField release];
        } else if (row == areasCityRow) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ServedCityCellIdentifier];
            cell.detailTextLabel.text = @"City";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-100, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:txtField];
            [txtField release];
        } else if (row == areasCountyRow) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ServedCountyCellIdentifier];
            cell.detailTextLabel.text = @"County";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+80, cell.frame.origin.y+11, cell.frame.size.width-100, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:txtField];
            [txtField release];
		}
	} else if (section == volunteerSection) {
		if (row == 0) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:VolunteerCellIdentifier];
            cell.detailTextLabel.text = @"Keywords";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+100, cell.frame.origin.y+11, cell.frame.size.width-120, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:txtField];
            [txtField release];
		}
	} else if (section == wishlistSection) {
		if (row == 0) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:WishListCellIdentifier];
            cell.detailTextLabel.text = @"Keywords";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+100, cell.frame.origin.y+11, cell.frame.size.width-120, 31)];
            txtField.delegate = self;
            [txtField setReturnKeyType:UIReturnKeyDone];
            [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            txtField.placeholder = @"";
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:txtField];
            
            [txtField release];
		}
	} else if (section == sheltersSection) {
        if (row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:SheltersCellIdentifier];
            cell.detailTextLabel.text = @"Show Only Shelters";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UISegmentedControl* scField = [[UISegmentedControl alloc] initWithFrame:CGRectMake(cell.frame.origin.x+175, cell.frame.origin.y+8, cell.frame.size.width-190, 31)];
            [scField insertSegmentWithTitle:@"Yes" atIndex:0 animated:NO];
            [scField insertSegmentWithTitle:@"No" atIndex:1 animated:NO];
            [scField setSelectedSegmentIndex:1];
            [cell.contentView addSubview:scField];
            [scField release];
        }
    } else if (section == serviceCodesSection) {
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
            [cell.contentView addSubview:txtField];
            [txtField release];
        }
    }
    
    NSString *cellId = [NSString stringWithFormat:@"id_%lu_%lu", (unsigned long)section, (unsigned long)row];
    [cellDictionary setObject:cell forKey:cellId];
    
    [cell release];
}

- (void) viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
    
	NSDictionary* previousParameters = [[XServicesHelper sharedInstance] lastQueryParams];
	if(previousParameters != nil){
        if ([[[settingsHelper settings] valueForKey:@"show_refine_keywords_all"] boolValue] == YES) {
            [self textFieldForSection:keywordsSection row:allRow].text = [previousParameters objectForKey:kXSQueryKeywordsAll];
        }
        if ([[[settingsHelper settings] valueForKey:@"show_refine_keywords_any"] boolValue] == YES) {
            if ([previousParameters objectForKey:kXSQueryNatural]) {
                [self textFieldForSection:keywordsSection row:anyRow].text = [previousParameters objectForKey:kXSQueryNatural];
            } else {
                [self textFieldForSection:keywordsSection row:anyRow].text = [previousParameters objectForKey:kXSQueryKeywordsAny];
            }
        }
        if ([[[settingsHelper settings] valueForKey:@"show_refine_keywords_none"] boolValue] == YES) {
            [self textFieldForSection:keywordsSection row:noneRow].text = [previousParameters objectForKey:kXSQueryKeywordsNone];
        }

        if ([[[settingsHelper settings] valueForKey:@"show_refine_location_zip"] boolValue] == YES) {
            [self textFieldForSection:physicalSection row:physicalZipRow].text = [previousParameters objectForKey:kXSQueryPhysicalLocationZIP];
        }
        if ([[[settingsHelper settings] valueForKey:@"show_refine_location_city"] boolValue] == YES) {
            [self textFieldForSection:physicalSection row:physicalCityRow].text = [previousParameters objectForKey:kXSQueryPhysicalLocationCity];
        }
        if ([[[settingsHelper settings] valueForKey:@"show_refine_location_county"] boolValue] == YES) {
            [self textFieldForSection:physicalSection row:physicalCountyRow].text = [previousParameters objectForKey:kXSQueryPhysicalLocationCounty];
        }
        
        if ([[[settingsHelper settings] valueForKey:@"show_refine_area_zip"] boolValue] == YES) {
            [self textFieldForSection:areasSection row:areasZipRow].text = [previousParameters objectForKey:kXSQueryGeoServedZIP];
        }
        if ([[[settingsHelper settings] valueForKey:@"show_refine_area_city"] boolValue] == YES) {
            [self textFieldForSection:areasSection row:areasCityRow].text = [previousParameters objectForKey:kXSQueryGeoServedCity];
        }
        if ([[[settingsHelper settings] valueForKey:@"show_refine_area_county"] boolValue] == YES) {
            [self textFieldForSection:areasSection row:areasCountyRow].text = [previousParameters objectForKey:kXSQueryGeoServedCounty];
        }

		if ([[[settingsHelper settings] valueForKey:@"show_refine_volunteer_op"] boolValue] == YES) {
            [self textFieldForSection:volunteerSection row:0].text = [previousParameters objectForKey:kXSQueryVolunteerKeywords];
        }

        if ([[[settingsHelper settings] valueForKey:@"show_refine_wishlist"] boolValue] == YES) {
            [self textFieldForSection:wishlistSection row:0].text = [previousParameters objectForKey:kXSQueryWishlistKeywords];
        }

        if ([[[settingsHelper settings] valueForKey:@"show_refine_shelters"] boolValue] == YES) {
            BOOL showOnlyShelters = NO;
            if ([previousParameters objectForKey:kXSQueryShowOnlyShelters] != nil
                && [[previousParameters objectForKey:kXSQueryShowOnlyShelters] isEqualToString:@"1"]) {
                showOnlyShelters = YES;
            }
            if (showOnlyShelters) {
                [self segmentedControlForSection:sheltersSection row:0].selectedSegmentIndex = 0;
            } else {
                [self segmentedControlForSection:sheltersSection row:0].selectedSegmentIndex = 1;
            }
        }

        if ([[[settingsHelper settings] valueForKey:@"show_refine_services"] boolValue] == YES) {
            [self textFieldForSection:serviceCodesSection row:0].text = [[previousParameters objectForKey:kXSQueryServiceCodes] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
	
	[super viewWillAppear:animated];
}

- (UITextField*) textFieldForSection:(NSUInteger)section row:(NSUInteger)row {
    NSString *cellId = [NSString stringWithFormat:@"id_%lu_%lu", (unsigned long)section, (unsigned long)row];
    UITableViewCell* cell = [cellDictionary objectForKey:cellId];

	for (UIView* view in [cell.contentView subviews]) {
		if([view isKindOfClass:[UITextField class]])
			return (UITextField*) view;
	}
    
    // Should never happen...
	return nil;
}

- (UISegmentedControl*) segmentedControlForSection:(NSUInteger)section row:(NSUInteger)row {
    NSString *cellId = [NSString stringWithFormat:@"id_%lu_%lu", (unsigned long)section, (unsigned long)row];
    UITableViewCell* cell = [cellDictionary objectForKey:cellId];
    
	for (UIView* view in [cell.contentView subviews]) {
		if([view isKindOfClass:[UISegmentedControl class]])
			return (UISegmentedControl*) view;
	}
	
	// Should never happen...
	return nil;
}

- (IBAction) cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) search:(id)sender {
	NSString* all = [[self textFieldForSection:keywordsSection row:allRow] text];
	NSString* any = [[self textFieldForSection:keywordsSection row:anyRow] text];
    NSString* none = [[self textFieldForSection:keywordsSection row:noneRow] text];
	
	NSString* physicalZip = [[self textFieldForSection:physicalSection row:physicalZipRow] text];
	NSString* physicalCity = [[self textFieldForSection:physicalSection row:physicalCityRow] text];
	NSString* physicalCounty = [[self textFieldForSection:physicalSection row:physicalCountyRow] text];
    
	NSString* geoZip = [[self textFieldForSection:areasSection row:areasZipRow] text];
	NSString* geoCity = [[self textFieldForSection:areasSection row:areasCityRow] text];
	NSString* geoCounty = [[self textFieldForSection:areasSection row:areasCountyRow] text];
	
	NSString* volunteer = [[self textFieldForSection:volunteerSection row:0] text];
	NSString* wishlist = [[self textFieldForSection:wishlistSection row:0] text];

    NSString* shelters;
    if ([[[settingsHelper settings] valueForKey:@"show_refine_shelters"] boolValue] == YES) {
        if([self segmentedControlForSection:sheltersSection row:0].selectedSegmentIndex == 1) {
            shelters = nil;
        } else {
            shelters = @"1";
        }
    } else {
        shelters = nil;
    }

    NSString* codes = [[self textFieldForSection:serviceCodesSection row:0] text];

	NSMutableDictionary* params;
    if ([[XServicesHelper sharedInstance] lastQueryParams]) {
        params = [[[XServicesHelper sharedInstance] lastQueryParams] mutableCopy];
        [params removeObjectForKey:kXSQueryNatural];
        [params removeObjectForKey:kXSQueryCommonId];
    } else {
        params = [NSMutableDictionary dictionary];
    }
    [params setObject:@"true" forKey:kXSQueryAdvanced];
    
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
    
    if(shelters)
        [params setObject:shelters forKey:kXSQueryShowOnlyShelters];
    else
        [params removeObjectForKey:kXSQueryShowOnlyShelters];

    if(codes)
        [params setObject:codes forKey:kXSQueryServiceCodes];
	
	[[XServicesHelper sharedInstance] searchResourcesWithQueryParams:params];
	[self.delegate setSearchBarText:@"(Advanced Search)"];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [cellDictionary release];
	[delegate release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int sections = 0;

    if ([[[settingsHelper settings] valueForKey:@"show_refine_keywords_all"] boolValue] == YES
        || [[[settingsHelper settings] valueForKey:@"show_refine_keywords_any"] boolValue] == YES
        || [[[settingsHelper settings] valueForKey:@"show_refine_keywords_none"] boolValue] == YES) {
        sections++;
    }
    
    if ([[[settingsHelper settings] valueForKey:@"show_refine_location_zip"] boolValue] == YES
        || [[[settingsHelper settings] valueForKey:@"show_refine_location_city"] boolValue] == YES
        || [[[settingsHelper settings] valueForKey:@"show_refine_location_county"] boolValue] == YES) {
        sections++;
    }
    
    if ([[[settingsHelper settings] valueForKey:@"show_refine_area_zip"] boolValue] == YES
        || [[[settingsHelper settings] valueForKey:@"show_refine_area_city"] boolValue] == YES
        || [[[settingsHelper settings] valueForKey:@"show_refine_area_county"] boolValue] == YES) {
        sections++;
    }

    if ([[[settingsHelper settings] valueForKey:@"show_refine_volunteer_op"] boolValue] == YES) {
        sections++;
    }
    
    if ([[[settingsHelper settings] valueForKey:@"show_refine_wishlist"] boolValue] == YES) {
        sections++;
    }
    
    if ([[[settingsHelper settings] valueForKey:@"show_refine_shelters"] boolValue] == YES) {
        sections++;
    }
    
    if ([[[settingsHelper settings] valueForKey:@"show_refine_services"] boolValue] == YES) {
        sections++;
    }

    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int currentSection = -1, row = 0;
    
    if ([[[settingsHelper settings] valueForKey:@"show_refine_keywords_all"] boolValue] == YES) {
        row++;
    }
    if ([[[settingsHelper settings] valueForKey:@"show_refine_keywords_any"] boolValue] == YES) {
        row++;
    }
    if ([[[settingsHelper settings] valueForKey:@"show_refine_keywords_none"] boolValue] == YES) {
        row++;
    }
    if (row > 0) {
        currentSection++;
    }
    if (section == currentSection) {
        return row;
    }
    
    row = 0;
    if ([[[settingsHelper settings] valueForKey:@"show_refine_location_zip"] boolValue] == YES) {
        row++;
    }
    if ([[[settingsHelper settings] valueForKey:@"show_refine_location_city"] boolValue] == YES) {
        row++;
    }
    if ([[[settingsHelper settings] valueForKey:@"show_refine_location_county"] boolValue] == YES) {
        row++;
    }
    if (row > 0) {
        currentSection++;
    }
    if (section == currentSection) {
        return row;
    }
    
    row = 0;
    if ([[[settingsHelper settings] valueForKey:@"show_refine_area_zip"] boolValue] == YES) {
        row++;
    }
    if ([[[settingsHelper settings] valueForKey:@"show_refine_area_city"] boolValue] == YES) {
        row++;
    }
    if ([[[settingsHelper settings] valueForKey:@"show_refine_area_county"] boolValue] == YES) {
        row++;
    }
    if (row > 0) {
        currentSection++;
    }
    if (section == currentSection) {
        return row;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    // Return a title or nil as appropriate for the section.
    if(section == keywordsSection) {
		title = @"Keywords";
    } else if (section == volunteerSection) {
		title = @"Volunteer Opportunities";
	} else if (section == wishlistSection) {
		title = @"Wishlists";
	} else if (section == sheltersSection) {
        title = @"Shelters";
    } else if (section == serviceCodesSection) {
        title = @"Services";
    }
    
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == physicalSection) {
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
	} else if (section == areasSection) {
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
    NSString *cellId = [NSString stringWithFormat:@"id_%ld_%ld", (long)indexPath.section, (long)indexPath.row];
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
