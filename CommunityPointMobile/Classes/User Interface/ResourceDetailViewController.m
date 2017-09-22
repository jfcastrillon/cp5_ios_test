//
//  ResourceDetailViewController.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/4/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ResourceDetailViewController.h"
#import "ResourceMapViewController.h"
#import "ResourceUnitsViewController.h"
#import "CPMResource.h"
#import "CPMResourceDetail.h"
#import "CPMService.h"
#import "Util.h"

#define LOCATION_SECTION 0
#define DETAILS_SECTION 1
#define SHELTER_SECTION 2
#define SERVICES_SECTION 3
#define GENERAL_SECTION 4

#define SHARE_EMAIL_BUTTON 0
#define SHARE_SMS_BUTTON 1

@implementation ResourceDetailViewController


@synthesize nameLabel, buttonContainer, loadingOverlay, favoriteButton, shareButton, tableView;

@dynamic displayedResource;

- (CPMResourceDetail*) displayedResource {
    return displayedResource;
}

- (void) setDisplayedResource:(CPMResourceDetail*) newResource{
    if(newResource != displayedResource){
        [displayedResource release];
        displayedResource = newResource;

        if([displayedResource primaryAddress] != nil) {
            addressText = [[displayedResource primaryAddress] multilineStringValue];
            [addressText retain];
        }

        // Zach
        if (!showServices) {
            showServices = [[NSMutableDictionary alloc] init];
        }
        for (CPMService* service in [[displayedResource services] objectForKey:@"primary"]) {
            [showServices setObject:[NSNumber numberWithBool:false] forKey:[service name]];
        }
        
        [displayedResource retain];
        [self updateDisplay];
    }
}

- (void) didReceiveResourceDetails: (NSNotification*) notification {
    [self setDisplayedResource: [xsHelper currentResource]];
}

- (void) resourceRequestFailed: (NSNotification*) notification {
    UIAlertView *alert;
    if(![[NetworkManager sharedInstance] isInternetConnectionAvailable]) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet connection available.  A data connection is required to use this app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //Trigger app lockdown?
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to retrieve resource details.  It appears the service is down." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }

    [alert show];
    [alert release];
}

- (IBAction) favoriteButtonPressed: (id) sender {
    [xsHelper addResourceToFavorites: displayedResource];
    [self updateDisplay];
}

- (IBAction) shareButtonPressed: (id) sender {
    UIActionSheet *shareTypeSheet = [[UIActionSheet alloc] initWithTitle:@"Share Resource Using:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
                                                       otherButtonTitles:@"Email", nil];

    int cancelIndex = 1;

    // We must always check whether the current device is configured for sending sms
    Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (smsClass != nil && [smsClass canSendText])
    {
        [shareTypeSheet addButtonWithTitle:@"SMS"];
        cancelIndex++;
    }

    [shareTypeSheet addButtonWithTitle:@"Cancel"];
    [shareTypeSheet setCancelButtonIndex:cancelIndex];

    [shareTypeSheet showInView:self.parentViewController.tabBarController.view];
    [shareTypeSheet release];
}

- (void) updateDisplay {
    if(displayedResource != nil){
        nameLabel.text = displayedResource.name;

        [nameLabel setHidden: NO];
        [buttonContainer setHidden: NO];
        [self.tableView reloadData];

        CATransition *animation = [CATransition animation];
        [animation setType: kCATransitionFade];
        [animation setDuration: 0.3];
        [animation setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[loadingOverlay layer] addAnimation:animation forKey:@"overlayTransition"];
        loadingOverlay.hidden = YES;
        loadingOverlay.alpha  = 0.0f;

        // If the resource is a favorite, hide the "Add to Favorites" button
        if ([xsHelper isResourceInFavorites: displayedResource]) {
            [favoriteButton setHidden: YES];
            [shareButton setFrame:CGRectMake(10, 8, 302, 37)];
        }
        // Otherwise, show the "Add to Favorites" button
        else {
            [favoriteButton setHidden: NO];
            [shareButton setFrame:CGRectMake(10, 8, 142, 37)];
        }
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    xsHelper = [XServicesHelper sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didReceiveResourceDetails:) name:@"ResourceDetailsReceived" object: xsHelper];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(resourceRequestFailed:) name:@"ResourceRequestFailed" object: xsHelper];
    [self.tableView setAllowsMultipleSelection:YES];

    addressCellIndex = UINT_MAX;
    phoneCellIndex = UINT_MAX;
    urlCellIndex = UINT_MAX;
    hoursCellIndex = UINT_MAX;
    programFeesCellIndex = UINT_MAX;
    languagesCellIndex = UINT_MAX;
    eligibilityCellIndex = UINT_MAX;
    intakeProcedureCellIndex = UINT_MAX;
    accessibilityCellIndex = UINT_MAX;
    shelterCellIndex = UINT_MAX;
    shelterRequirementsCellIndex = UINT_MAX;

    locationSectionIndex = UINT_MAX;
    shelterSectionIndex = UINT_MAX;
    detailsSectionIndex = UINT_MAX;
    servicesSectionIndex = UINT_MAX;
    generalInfoSectionIndex = UINT_MAX;

    if(displayedResource == nil) {
        [loadingOverlay setHidden: NO];
    } else {
        [self updateDisplay];
    }

    [super viewDidLoad];


}


- (void) viewWillAppear:(BOOL)animated {
    if(displayedResource != nil) {
        [tableView reloadData];
    }

    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    // Stop listening for the data update
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ResourceDetailsReceived" object:xsHelper];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ResourceRequestFailed" object:xsHelper];
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
    [[NSNotificationCenter defaultCenter] removeObserver: self];

    self.displayedResource = nil;
    self.nameLabel = nil;
    self.buttonContainer = nil;
    self.favoriteButton = nil;
    self.shareButton = nil;
    self.tableView = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [showServices release]; //Zach code
    [displayedResource release];
    [addressText release];
    [nameLabel release];
    [buttonContainer release];
    [favoriteButton release];
    [shareButton release];
    [tableView release];
    [super dealloc];
}

//Table data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(displayedResource == nil) {
        return 0;
    } else {
        NSUInteger count = 0;
        if([self numberOfRowsInSection:LOCATION_SECTION] > 0)
            locationSectionIndex = count++;
        if([self numberOfRowsInSection:SHELTER_SECTION] > 0)
            shelterSectionIndex = count++;
        if([self numberOfRowsInSection:DETAILS_SECTION] > 0)
            detailsSectionIndex = count++;
        if([self numberOfRowsInSection:SERVICES_SECTION] > 0)
            servicesSectionIndex = count++;
        if([self numberOfRowsInSection:GENERAL_SECTION] > 0)
            generalInfoSectionIndex = count++;
        return count;

    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    // Return a title or nil as appropriate for the section.
    if(section == locationSectionIndex || section == shelterSectionIndex) {
        // blank
    } else if (section == detailsSectionIndex) {
        title = @"Description";
    } else if (section == servicesSectionIndex) {
        title = @"Primary Services Offered";
    } else if (section == generalInfoSectionIndex) {
        title = @"General Information";
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == locationSectionIndex)
        return [self numberOfRowsInSection:LOCATION_SECTION];
    else if (section == shelterSectionIndex)
        return [self numberOfRowsInSection:SHELTER_SECTION];
    else if (section == detailsSectionIndex)
        return [self numberOfRowsInSection:DETAILS_SECTION];
    else if (section == servicesSectionIndex)
        return [self numberOfRowsInSection:SERVICES_SECTION];
    else if (section == generalInfoSectionIndex)
        return [self numberOfRowsInSection:GENERAL_SECTION];
    else
        return 0;
}

- (NSInteger) numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
        case LOCATION_SECTION:
            if([addressText length] > 0)
                addressCellIndex = rows++;
            if (displayedResource.phone != nil && [displayedResource.phone length] > 0)
                phoneCellIndex = rows++;
            if (displayedResource.url != nil && [displayedResource.url length] > 0)
                urlCellIndex = rows++;
            break;
        case SHELTER_SECTION:
            if ([[[[SettingsHelper sharedInstance] settings] valueForKey:@"show_shelter_info"] boolValue] == YES
                && [displayedResource unitInfos] != nil && [[displayedResource unitInfos] count] > 0) {
                rows = 1;
            }
            break;
        case DETAILS_SECTION:
            rows = 1;
            break;
        case SERVICES_SECTION:
            if ([displayedResource services] != nil) {
                for (CPMService* service in [[displayedResource services] objectForKey:@"primary"]) {
                    // Skip the 'Y' service code tree
                    if (![[service code] hasPrefix:@"Y"]) {
                        if ([service name] != nil && [[service name] length] > 0) {
                            rows++;
                           // rows = rows + 16;
                        }
                         CPMServiceDetail *serviceDetails = [service serviceDetails];
                         if ([serviceDetails applicationProcess] != nil && [[serviceDetails applicationProcess] length] > 0) {
                         rows++;
                         }
                         if ([serviceDetails capacity] != nil && [[serviceDetails capacity] length] > 0) {
                         rows++;
                         }
                         if ([serviceDetails description] != nil && [[serviceDetails description] length] > 0) {
                         rows++;
                         }
                         if ([serviceDetails eligibilityRequirements] != nil && [[serviceDetails eligibilityRequirements] length] > 0) {
                         rows++;
                         }
                         if ([serviceDetails feeStructure] != nil && [[serviceDetails feeStructure] length] > 0) {
                         rows++;
                         }
                         if ([serviceDetails hours] != nil && [[serviceDetails hours] length] > 0) {
                         rows++;
                         }
                         if ([serviceDetails languages] != nil && [[serviceDetails languages] length] > 0) {                            rows++;
                         }
                         if ([serviceDetails notes] != nil && [[serviceDetails notes] length] > 0) {                            rows++;
                         }
                         if ([serviceDetails requiredDocuments] != nil && [[serviceDetails requiredDocuments] length] > 0) {
                         rows++;
                         }
                         if ([serviceDetails serviceArea] != nil && [[serviceDetails serviceArea] length] > 0) {
                         rows++;
                         }
                        CPMResourceContact *resourceContact = [serviceDetails resourceContact];
                        if (resourceContact != nil && [[resourceContact name] length] > 0) {
                            rows++;
                        }
                       /* if ([resourceContact name] != nil && [[resourceContact name] length] > 0) {
                            rows++;
                        }
                        if ([resourceContact title] != nil && [[resourceContact title] length] > 0) {
                            rows++;
                        }
                        if ([resourceContact description] != nil && [[resourceContact description] length] > 0) {
                            rows++;
                        }
                        if ([resourceContact phone] != nil && [[resourceContact phone] length] > 0) {
                            rows++;
                        }
                        if ([resourceContact email] != nil && [[resourceContact email] length] > 0) {
                            rows++;
                        }
                        if ([resourceContact websiteAddress] != nil && [[resourceContact websiteAddress] length] > 0) {
                            rows++;
                        }

*/
                    /*    for (CPMServiceTelephone* servPhone in [[displayedResource serviceDetails] objectForKey:@"telephone_numbers"]) {

                            if([servPhone name] != nil) {
                                rows++;
                            }

                            
                        }*/


                    }
                }
                break;
            }
            return rows;
        case GENERAL_SECTION:
            if ([displayedResource hours] != nil && [[displayedResource hours] length] > 0) {
                hoursCellIndex = rows;
                rows++;
            }
            if ([displayedResource programFees] != nil && [[displayedResource programFees] length] > 0) {
                programFeesCellIndex = rows;
                rows++;
            }
            if ([displayedResource languages] != nil && [[displayedResource languages] length] > 0) {
                languagesCellIndex = rows;
                rows++;
            }
            if ([displayedResource eligibility] != nil && [[displayedResource eligibility] length] > 0) {
                eligibilityCellIndex = rows;
                rows++;
            }
            if ([displayedResource intakeProcedure] != nil && [[displayedResource intakeProcedure] length] > 0) {
                intakeProcedureCellIndex = rows;
                rows++;
            }
            if ([[displayedResource accessibilityFlag] boolValue]) {
                accessibilityCellIndex = rows;
                rows++;
            }
            if ([[displayedResource isShelter] boolValue]) {
                shelterCellIndex = rows;
                rows++;

                if ([displayedResource shelterRequirements] != nil && [[displayedResource shelterRequirements] length] > 0) {
                    shelterRequirementsCellIndex = rows;
                    rows++;
                }
            }

            break;
        default:
            break;
    }
    return rows;
}


- (UITableViewCell*)tableView:(UITableView*)_tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString *ResourceDetailCellIdentifier = @"ResourceDetailCell";
    static NSString *ResourceLocationCellIdentifier = @"ResourceLocationCell";
    static NSString *ResourceActionCellIdentifier = @"ResourceActionCell";
    static NSString *ResourceServiceCellIdentifier = @"ResourceServiceCell";
    static NSString *ResourceGeneralCellIdentifier = @"ResourceGeneralCell";

    UITableViewCell *cell = nil;
    if (indexPath.section == locationSectionIndex) {
        NSUInteger row = [indexPath row];

        if (row == addressCellIndex){
            cell = [_tableView dequeueReusableCellWithIdentifier:ResourceLocationCellIdentifier];
            if(cell == nil){
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceLocationCellIdentifier] autorelease];
            }

            /*if([displayedResource longitude] == nil) {
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
             cell.accessoryType = UITableViewCellAccessoryNone;
             } else {*/
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //}

            //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            //cell.textLabel.text = @"Address";
            cell.textLabel.text = addressText;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell.detailTextLabel.numberOfLines = 0;
            //cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            return cell;
        } else if (row == phoneCellIndex) {
            cell = [_tableView dequeueReusableCellWithIdentifier:ResourceLocationCellIdentifier];
            if(cell == nil){
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceLocationCellIdentifier] autorelease];
            }

            //cell.textLabel.text = @"Phone";
            cell.textLabel.text = [displayedResource phone];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;


            return cell;
        } else if (row == urlCellIndex) {
            cell = [_tableView dequeueReusableCellWithIdentifier:ResourceActionCellIdentifier];
            if(cell == nil){
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceActionCellIdentifier] autorelease];
            }

            cell.textLabel.text = @"View Website";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:0.25098 blue:0.501961 alpha:1.0];
            return cell;
        }


    } else if (indexPath.section == shelterSectionIndex) {
        cell = [_tableView dequeueReusableCellWithIdentifier:ResourceActionCellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceActionCellIdentifier] autorelease];
        }

        cell.textLabel.text = @"View Shelter Information";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else if (indexPath.section == detailsSectionIndex) {
        NSUInteger row = [indexPath row];

        switch (row) {
            case 0:
            {
                cell = [_tableView dequeueReusableCellWithIdentifier:ResourceDetailCellIdentifier];
                if(cell == nil){
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceDetailCellIdentifier] autorelease];
                }

                cell.textLabel.text = [displayedResource description];
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                //cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
                break;
        }
    } else if (indexPath.section == servicesSectionIndex) {
        NSUInteger row = [indexPath row];

        int currentIndex = 0;
        
        for (CPMService* service in [[displayedResource services] objectForKey:@"primary"]) {
            // Skip the 'Y' service code tree
            if (![[service code] hasPrefix:@"Y"]) {
                if (currentIndex == row) {
                    cell = [_tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
                    if(cell == nil){
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier] autorelease];
                    }
                    
                    cell.textLabel.adjustsFontSizeToFitWidth = YES;
                    cell.textLabel.text = [service name];
                    cell.indentationLevel = 0;
                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0 ];
                    cell.textLabel.textColor = [UIColor blueColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }

                currentIndex++;


                CPMServiceDetail* serviceDetails = [service serviceDetails];
                cell = [_tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
                if(cell == nil){
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier] autorelease];
                }

                // printf("%d", currentIndex);
                if (currentIndex == row && [serviceDetails applicationProcess] != nil) {
                        cell = [_tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
                        if(cell == nil){
                            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier] autorelease];
                        }


                        NSString* txtLabel =  @"Intake Procedure:";
                        NSString* txtDetail = [serviceDetails applicationProcess];
                        NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
                        cell.textLabel.text = strCell;
                        cell.indentationLevel = 1;
                        cell.textLabel.numberOfLines = 0;

                        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    break;
                }
                if(([serviceDetails applicationProcess]) != nil) {
                currentIndex++;
                }

                if (currentIndex == row && [serviceDetails capacity] != nil) {
                    cell = [_tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
                    if(cell == nil){
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier] autorelease];
                    }

                    NSString* txtLabel =  @"Capcity:";
                    NSString* txtDetail = [serviceDetails applicationProcess];
                    NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
                    cell.textLabel.text = strCell;
                    cell.indentationLevel = 1;
                    cell.textLabel.numberOfLines = 0;

                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    break;
                }
                if ([serviceDetails capacity] != nil) {
                currentIndex++;
                }
                if (currentIndex == row && [serviceDetails description] != nil) {

                    cell = [_tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
                    if(cell == nil){
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier] autorelease];
                    }

                    NSString* txtLabel =  @"Description:";
                    NSString* txtDetail = [serviceDetails description];
                    NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
                    cell.textLabel.text = strCell;

                    cell.indentationLevel = 1;
                    cell.textLabel.numberOfLines = 0;

                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;

                }
                if ([serviceDetails description] != nil) {
                currentIndex++;
                }
                if (currentIndex == row && [serviceDetails eligibilityRequirements] != nil) {
                    cell = [_tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
                    if(cell == nil){
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier] autorelease];
                    }

                    NSString* txtLabel =  @"Eligibility Requiremments:";
                    NSString* txtDetail = [serviceDetails eligibilityRequirements];
                    NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
                    cell.textLabel.text = strCell;
                    cell.indentationLevel = 1;
                    cell.textLabel.numberOfLines = 0;

                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                if ([serviceDetails eligibilityRequirements] != nil) {
                currentIndex++;
                }
                if (currentIndex == row && [serviceDetails feeStructure] != nil) {
                    cell = [_tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
                    if(cell == nil){
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier] autorelease];
                    }

                    NSString* txtLabel =  @"Fees:";
                    NSString* txtDetail = [serviceDetails feeStructure];
                    NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
                    cell.textLabel.text = strCell;
                    cell.indentationLevel = 1;
                    cell.textLabel.numberOfLines = 0;

                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                if ([serviceDetails feeStructure] != nil) {
                currentIndex++;
                }
                if (currentIndex == row && [serviceDetails hours] != nil) {
                    cell = [_tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
                    if(cell == nil){
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier] autorelease];
                    }

                    NSString* txtLabel =  @"Hours:";
                    NSString* txtDetail = [serviceDetails hours];
                    NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
                    cell.textLabel.text = strCell;
                    cell.indentationLevel = 1;
                    cell.textLabel.numberOfLines = 0;

                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                if ([serviceDetails hours] != nil) {
                currentIndex++;
                }
                if (currentIndex == row && [serviceDetails languages] != nil) {
                    cell = [_tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
                    if(cell == nil){
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier] autorelease];
                    }

                    NSString* txtLabel =  @"Languages:";
                    NSString* txtDetail = [serviceDetails languages];
                    NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
                    cell.textLabel.text = strCell;
                    cell.indentationLevel = 1;
                    cell.textLabel.numberOfLines = 0;

                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                if ([serviceDetails languages] != nil) {
                currentIndex++;
                }
                if (currentIndex == row && [serviceDetails notes] != nil) {
                    cell = [_tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
                    if(cell == nil){
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier] autorelease];
                    }

                    NSString* txtLabel =  @"Notes:";
                    NSString* txtDetail = [serviceDetails notes];
                    NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
                    cell.textLabel.text = strCell;
                    cell.indentationLevel = 1;
                    cell.textLabel.numberOfLines = 0;

                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                if ([serviceDetails notes] != nil) {
                currentIndex++;
                }
                if (currentIndex == row && [serviceDetails requiredDocuments] != nil) {
                    cell = [_tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
                    if(cell == nil){
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier] autorelease];
                    }

                    NSString* txtLabel =  @"Required Documents:";
                    NSString* txtDetail = [serviceDetails requiredDocuments];
                    NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
                    cell.textLabel.text = strCell;
                    cell.indentationLevel = 1;
                    cell.textLabel.numberOfLines = 0;

                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;

                }
                if ([serviceDetails requiredDocuments] != nil) {
                currentIndex++;
                }
                if (currentIndex == row && [serviceDetails serviceArea] != nil) {
                    cell = [_tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
                    if(cell == nil){
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier] autorelease];
                    }

                    NSString* txtLabel =  @"Service Area:";
                    NSString* txtDetail = [serviceDetails serviceArea];
                    NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
                    cell.textLabel.text = strCell;
                    cell.indentationLevel = 1;
                    cell.textLabel.numberOfLines = 0;

                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                if ([serviceDetails serviceArea] != nil) {
                    currentIndex++;
                }
                CPMResourceContact *resourceContact = [serviceDetails resourceContact];
                if (currentIndex == row) {
                    if ([resourceContact name] !=nil) {
                        cell = [_tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
                        if(cell == nil){
                            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier] autorelease];
                        }

                        NSMutableString *teststring = [[NSMutableString alloc]init];
                        [teststring appendString:@"Contact Information\n"];

                        //NSString* txtLabel =  @"Contact Information";
                        [teststring appendString:[resourceContact name]];

                        //NSString* txtName = [[resourceContact name];
                        //NSString* txtDetail = nil;
                        if([resourceContact title] != nil && [[resourceContact title] length] > 0) {
                            [teststring appendString:@"\n"];
                            [teststring appendString:[resourceContact title]];
                        }
                        if([resourceContact description] != nil && [[resourceContact description] length] > 0) {
                            [teststring appendString:@"\n"];
                            [teststring appendString:[resourceContact description]];
                        }
                        if([resourceContact phone] != nil && [[resourceContact phone] length] > 0) {
                            [teststring appendString:@"\n"];
                            [teststring appendString:[resourceContact phone]];

                        }
                        if([resourceContact email] != nil && [[resourceContact email] length] > 0) {
                            [teststring appendString:@"\n"];
                            [teststring appendString:[resourceContact email]];

                        }
                        if([resourceContact websiteAddress] != nil && [[resourceContact websiteAddress] length] > 0) {
                            [teststring appendString:@"\n"];
                            [teststring appendString:[resourceContact websiteAddress]];

                        }
                        cell.textLabel.text = teststring;
                        cell.indentationLevel = 1;
                        cell.textLabel.numberOfLines = 0;

                        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        break;
                    }
                }
                if ([resourceContact name] != nil) {
                    currentIndex++;
                }
                
                /* for (CPMServiceTelephone* servPhone in [[service serviceTelephones objectForKey:@"bin"]){
                   //  CPMServiceTelephone* serviceTelephone = [servPhone ]
                     NSLog(@"Response servPhone=%@", [servPhone name]);
                    if (currentIndex == row) {
                        if ([servPhone name] !=nil) {
                            cell = [_tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
                            if(cell == nil){
                                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier] autorelease];
                            }

                            NSMutableString *teststring = [[NSMutableString alloc]init];
                            [teststring appendString:@"Telephone Numbers\n"];

                            //NSString* txtLabel =  @"Contact Information";
                            [teststring appendString:[servPhone name]];

                            cell.textLabel.text = teststring;
                            cell.indentationLevel = 1;
                            cell.textLabel.numberOfLines = 0;

                            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            break;

                        }
                        currentIndex++;
                    }
                     if ([servPhone name] != nil) {
                         currentIndex++;
                     }
                }*/


            }
        }

    } else if (indexPath.section == generalInfoSectionIndex) {
        NSUInteger row = [indexPath row];

        cell = [_tableView dequeueReusableCellWithIdentifier:ResourceGeneralCellIdentifier];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceGeneralCellIdentifier] autorelease];
        }

        if (row == hoursCellIndex) {
            NSString* txtLabel =  @"Hours:";
            NSString* txtDetail = [displayedResource hours];
            NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
            cell.textLabel.text = strCell;
        } else if (row == programFeesCellIndex) {
            //cell.textLabel.text = @"program fees";
            //cell.detailTextLabel.text = [displayedResource programFees];
            NSString* txtLabel =  @"Program Fees:";
            NSString* txtDetail = [displayedResource programFees];
            NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
            cell.textLabel.text = strCell;		}
        else if (row == languagesCellIndex) {
            //cell.textLabel.text = @"languages";
            //cell.detailTextLabel.text = [displayedResource languages];
            NSString* txtLabel =  @"Languages:";
            NSString* txtDetail = [displayedResource languages];
            NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
            cell.textLabel.text = strCell;		}
        else if (row == eligibilityCellIndex) {
            //cell.textLabel.text = @"eligibility";
            //cell.detailTextLabel.text = [displayedResource eligibility];
            NSString* txtLabel =  @"Eligibility:";
            NSString* txtDetail = [displayedResource eligibility];
            NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
            cell.textLabel.text = strCell;		}
        else if (row == intakeProcedureCellIndex) {
            //cell.textLabel.text = @"intake process";
            //cell.detailTextLabel.text = [displayedResource intakeProcedure];
            NSString* txtLabel =  @"Intake Process:";
            NSString* txtDetail = [displayedResource intakeProcedure];
            NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
            cell.textLabel.text = strCell;

        }
        else if (row == accessibilityCellIndex) {
            //cell.textLabel.text = @"handicap accessible";
            //cell.detailTextLabel.text = @"Yes";
            NSString* txtLabel =  @"Handicap Accessible:";
            NSString* txtDetail = @"Yes";
            NSString* strCell = [NSString stringWithFormat:@"%@%@", txtLabel,txtDetail];
            cell.textLabel.text = strCell;		}
        else if (row == shelterCellIndex) {
            //cell.textLabel.text = @"shelter";
            //cell.detailTextLabel.text = @"Yes";
            NSString* txtLabel =  @"Shelter:";
            NSString* txtDetail = @"Yes";
            NSString* strCell = [NSString stringWithFormat:@"%@%@", txtLabel,txtDetail];
            cell.textLabel.text = strCell;		}
        else if (row == shelterRequirementsCellIndex) {
            //cell.textLabel.text = @"shelter requirements";
            //cell.detailTextLabel.text = [displayedResource shelterRequirements];
            NSString* txtLabel =  @"Shelter Requirements:";
            NSString* txtDetail = [displayedResource shelterRequirements];
            NSString* strCell = [NSString stringWithFormat:@"%@\n%@", txtLabel,txtDetail];
            cell.textLabel.text = strCell;
        }
        /*cell.textLabel.adjustsFontSizeToFitWidth = YES;
         cell.textLabel.adjustsLetterSpacingToFitWidth = YES;
         cell.textLabel.numberOfLines = 2;
         cell.detailTextLabel.numberOfLines = 0;
         cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
         cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         */

        cell.textLabel.numberOfLines = 0;

        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.headers objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section] == detailsSectionIndex && [indexPath row] == 0){
        NSString *cellText = [displayedResource description];
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0];
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];

        return MAX(labelSize.height + 20, 44.0f);
    } else if ([indexPath section] == locationSectionIndex && [indexPath row] == addressCellIndex) {
        NSString *cellText = addressText;
        UIFont *cellFont = [UIFont boldSystemFontOfSize:15.0f];
        //UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:21.0];
        //CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        CGSize constraintSize;
        if ([displayedResource longitude] == nil) {
            constraintSize = CGSizeMake(207.0f, MAXFLOAT);
        } else {
            constraintSize = CGSizeMake(187.0f, MAXFLOAT);
        }
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];

        return labelSize.height + 20;

    }  else if ([indexPath section] == servicesSectionIndex) {
        /* NSString *cellText = [displayedResource description];
         UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0];
         CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
         CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];

         return MAX(labelSize.height + 20, 44.0f);
         */
        for (CPMService* service in [[displayedResource services] objectForKey:@"primary"]) {
            // Skip the 'Y' service code tree

            NSString *cellTextLabel = nil;
            NSString *cellText = nil;
            if (![[service code] hasPrefix:@"Y"]) {
                CPMServiceDetail *serviceDetails = [service serviceDetails];

                if ([serviceDetails applicationProcess] != nil && [[serviceDetails applicationProcess] length] > 0) {
                    cellTextLabel = @"Intake Procedure:\n";
                    cellText = [serviceDetails applicationProcess];

                }
                if ([serviceDetails capacity] != nil && [[serviceDetails capacity] length] > 0) {
                    cellTextLabel = @"Capacity:\n";
                    cellText = [serviceDetails capacity];
                }
                if ([serviceDetails description] != nil && [[serviceDetails description] length] > 0) {
                    cellTextLabel = @"Description:\n";
                    cellText = [serviceDetails description];

                }
                if ([serviceDetails eligibilityRequirements] != nil && [[serviceDetails eligibilityRequirements] length] > 0) {
                    cellTextLabel = @"Eligibility:\n";
                    cellText = [serviceDetails eligibilityRequirements];
                }
                if ([serviceDetails feeStructure] != nil && [[serviceDetails feeStructure] length] > 0) {
                    cellTextLabel = @"Fees:\n";
                    cellText = [serviceDetails feeStructure];
                }
                if ([serviceDetails hours] != nil && [[serviceDetails hours] length] > 0) {
                    cellTextLabel = @"Hours:\n";
                    cellText = [serviceDetails hours];
                }
                if ([serviceDetails languages] != nil && [[serviceDetails languages] length] > 0) {                            cellTextLabel = @"Languages:\n";
                    cellText = [serviceDetails languages];
                }
                if ([serviceDetails notes] != nil && [[serviceDetails notes] length] > 0) {                            cellTextLabel = @"Notes:\n";
                    cellText = [serviceDetails notes];
                }
                if ([serviceDetails requiredDocuments] != nil && [[serviceDetails requiredDocuments] length] > 0) {
                    cellTextLabel = @"Required Documents:\n";
                    cellText = [serviceDetails requiredDocuments];
                }
                if ([serviceDetails serviceArea] != nil && [[serviceDetails serviceArea] length] > 0) {
                    cellTextLabel = @"Service Area:\n";
                    cellText =  [serviceDetails serviceArea];
                    
                }
             /*   for (CPMServiceTelephone* servPhone in [[displayedResource serviceDetails] objectForKey:@"telephone_numbers"]) {
                    
                    if ([servPhone name] !=nil) {
                        cellTextLabel = @"Telephone Numbers\n";
                        cellText = [servPhone name];
                    }
                    
                }*/
                                /*UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0];
                 CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
                 CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];

                 return MAX(labelSize.height + 20, 44.0f);*/

                //UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0];
                //CGSize constraintSize = CGSizeMake(207.0f, MAXFLOAT);
                ///CGSize constraintSize = CGSizeMake(self.tableView.frame.size.width - 50.0f, CGFLOAT_MAX);
                //CGSize labelSize = [cellTextLabel sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping ];
                //CGSize detailSize = [cellText sizeWithFont: cellFont constrainedToSize: constraintSize lineBreakMode: NSLineBreakByWordWrapping];

                //CGFloat result = MAX(44.0, labelSize.height + detailSize.height + 12.0);

                // Compares the index path for the current cell to the index path stored in the expanded
                // index path variable. If the two match, return a height of 100 points, otherwise return
                // a height of 44 points.

                // Zach
                if ([indexPath section] == servicesSectionIndex && [[showServices objectForKey: [service name]] boolValue]) {
                    return 44; // or if it's always the same, 44 + whatever
                }
                
                if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
                    return UITableViewAutomaticDimension; // Expanded height
                }
                return 44.0; // Normal height

            }
        }
    } else if ([indexPath section] == generalInfoSectionIndex) {
        NSUInteger row = [indexPath row];
        NSString *cellTextLabel = nil;
        NSString *cellText = nil;

        if (row == hoursCellIndex) {
            cellTextLabel = @"Hours:\n";
            cellText = [displayedResource hours];
        } else if (row == programFeesCellIndex) {
            cellTextLabel = @"Fees:\n";
            cellText = [displayedResource programFees];
        } else if (row == languagesCellIndex) {
            cellTextLabel = @"Languages:\n";
            cellText = [displayedResource languages];
        } else if (row == eligibilityCellIndex) {
            cellTextLabel = @"Eligibility:\n";
            cellText = [displayedResource eligibility];
        } else if (row == intakeProcedureCellIndex) {
            cellTextLabel = @"Intake Process:\n";
            cellText = [displayedResource intakeProcedure];
        } else if (row == accessibilityCellIndex) {
            cellTextLabel = @"Handicap Accessible:\n";
            cellText = @"Yes";
        } else if (row == shelterCellIndex) {
            cellTextLabel = @"Shelter:\n";
            cellText = @"Yes";
        } else {
            cellText = [displayedResource shelterRequirements];
        }

        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0];
        //CGSize constraintSize = CGSizeMake(207.0f, MAXFLOAT);
        CGSize constraintSize = CGSizeMake(self.tableView.frame.size.width - 40.0f, CGFLOAT_MAX);
        CGSize labelSize = [cellTextLabel sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping ];
        CGSize detailSize = [cellText sizeWithFont: cellFont constrainedToSize: constraintSize lineBreakMode: NSLineBreakByWordWrapping];

        CGFloat result = MAX(44.0, labelSize.height + detailSize.height + 10.0);
        return result;
    } else {
        return 44;
    }
    return 44;
}

// set up tapping service header to this action
- (void)toggleHeaderForService:(CPMService *)service {
    BOOL currentState = [[showServices objectForKey:service.name] boolValue];
    
    [tableView beginUpdates]; // Not sure if the project supports the newer block method, this will work though.
    [showServices setObject:[NSNumber numberWithBool:!currentState] forKey:service.name];
    [tableView endUpdates];
}

- (void) tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == locationSectionIndex) {
        if(indexPath.section == locationSectionIndex && indexPath.row == urlCellIndex){
            NSString *url = [displayedResource url];
            if(![[displayedResource url] hasPrefix: @"http://"]){
                url = [NSString stringWithFormat:@"http://%@", [displayedResource url]];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
        } else if (indexPath.section == locationSectionIndex && indexPath.row == phoneCellIndex) {
            NSString *urlString = [NSString stringWithFormat:@"tel:%@%@%@", [[displayedResource primaryPhone] areaCode], [[displayedResource primaryPhone] prefix], [[displayedResource primaryPhone] line]];
            NSURL *url = [NSURL URLWithString:urlString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        } else if(indexPath.section == locationSectionIndex && indexPath.row == addressCellIndex) {
            //if(displayedResource.latitude != nil) {

            ResourceMapViewController *mapViewController = [[ResourceMapViewController alloc] initWithNibName:@"ResourceMapViewController" bundle:[NSBundle mainBundle]];

            [self.navigationController pushViewController:mapViewController animated:YES];
            mapViewController.displayedResource = displayedResource;

            [mapViewController release];
            //}
        }
    } else if (indexPath.section == servicesSectionIndex) {
        // Zach
        NSArray *allServices = [[displayedResource services] objectForKey:@"primary"];
        // not 100% sure this is correct; may  have to filter out the Y codes and use that for the target of objectAtIndex
        // something like uncommenting the 2 lines below (predicate may not be exact, best guess :P)
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"!(code beginsWith %@) AND !(name == nil) AND (name.length > 0)", @"Y"];
         allServices = [allServices filteredArrayUsingPredicate:pred];
        CPMService *service = [allServices objectAtIndex:indexPath.row];
        [self toggleHeaderForService:service];
        ////////////////////////////////////
        
        [tableView beginUpdates]; // tell the table you're about to start making changes
        
        // If the index path of the currently expanded cell is the same as the index that
        // has just been tapped set the expanded index to nil so that there aren't any
        // expanded cells, otherwise, set the expanded index to the index that has just
        // been selected.
        if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
            self.expandedIndexPath = nil;
        } else {
            self.expandedIndexPath = indexPath;
        }
        
        [tableView endUpdates]; // tell the table you're done making your changes    } else if (indexPath.section == shelterSectionIndex) {
        ResourceUnitsViewController *unitViewController = [[ResourceUnitsViewController alloc] initWithNibName:@"ResourceUnitsViewController" bundle:[NSBundle mainBundle]];

        [self.navigationController pushViewController:unitViewController animated:YES];
        [unitViewController setDisplayedResource:displayedResource];

        [unitViewController release];
    }

    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

// Share Resource
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case SHARE_EMAIL_BUTTON:
            [self emailResource];
            break;
        case SHARE_SMS_BUTTON:
            if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"SMS"])
                [self smsResource];
            break;
        default:
            // They picked cancel
            return;
    }
}

// SMS a Resource
- (void)smsResource {
    MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc] init];
    message.messageComposeDelegate = self;
    message.body = buildSMS(displayedResource);
    [self presentModalViewController:message animated:YES];
    [message release];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissModalViewControllerAnimated:YES];
}

// Email a Resource
- (void)emailResource {
    // This can run on devices running iPhone OS 2.0 or later
    // The MFMailComposeViewController class is only available in iPhone OS 3.0 or later.
    // So, we must verify the existence of the above class and provide a workaround for devices running
    // earlier versions of the iPhone OS.
    // We display an email composition interface if MFMailComposeViewController exists and the device can send emails.
    // We launch the Mail application on the device, otherwise.

    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}

- (void)displayComposerSheet {
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.modalPresentationStyle = UIModalPresentationPageSheet;
    mail.mailComposeDelegate = self;

    [mail setSubject:@"CommunityPoint Resource Information"];

    NSString *emailBody = buildEmail(displayedResource);
    [mail setMessageBody:emailBody isHTML:YES];

    [self presentModalViewController:mail animated:YES];
    [mail release];
}

// Launches the Mail application on the device.
- (void)launchMailAppOnDevice {
    NSString *subject = @"mailto:?subject=CommunityPoint Resource Information";
    NSString *body = buildEmail(displayedResource);

    NSString *email = [NSString stringWithFormat:@"%@&body=%@", subject, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

// Dismisses the email composition interface when users tap Cancel or Send.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
