//
//  ResourceDetailViewController.m
//  CommunityPointMobile
//
//  Created by John Cannon on 4/4/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "ResourceDetailViewController.h"
#import "ResourceMapViewController.h"
#import "CPMResource.h"
#import "CPMResourceDetail.h"
#import "CPMService.h"
#import "Util.h"


#define LOCATION_SECTION 0
#define DETAILS_SECTION 1
#define SERVICES_SECTION 2
#define GENERAL_SECTION 3

#define SHARE_EMAIL_BUTTON 0
#define SHARE_SMS_BUTTON 1

@implementation ResourceDetailViewController


@synthesize nameLabel, buttonContainer, loadingOverlay, favoriteButton, shareButton;


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
	
	[shareTypeSheet showInView:self.view];
	[shareTypeSheet release];
}

- (void) updateDisplay {
	if(displayedResource != nil){
		nameLabel.text = displayedResource.name;

		[nameLabel setHidden: NO];
		[buttonContainer setHidden: NO];
		[self.tableView reloadData];
    	[loadingOverlay setHidden: YES];
		
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

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	xsHelper = [XServicesHelper sharedInstance];
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(didReceiveResourceDetails:) name:@"ResourceDetailsReceived" object: xsHelper];
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(resourceRequestFailed:) name:@"ResourceRequestFailed" object: xsHelper];
	
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
	
    [super viewDidLoad];
}


- (void) viewWillDisappear:(BOOL)animated {
	// Stop listening for the data update
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"ResourceDetailsReceived" object:xsHelper];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"ResourceRequestFailed" object:xsHelper];
	[super viewWillDisappear:animated];
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	
	self.nameLabel = nil;
	self.buttonContainer = nil;
	self.favoriteButton = nil;
	self.shareButton = nil;
	
	[super viewDidUnload];
}


- (void)dealloc {
	[displayedResource release];
	[addressText release];
	[nameLabel release];
	[buttonContainer release];
	[favoriteButton release];
	[shareButton release];
    [super dealloc];
}
	 
//Table data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if(displayedResource == nil) {
		return 0;
	} else {
		return 4;
	}
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    // Return a title or nil as appropriate for the section.
    switch (section) {
        case LOCATION_SECTION:
            break;
        case DETAILS_SECTION:
            title = @"Description";
            break;
		case SERVICES_SECTION:
			title = @"Primary Services Offered";
			break;
		case GENERAL_SECTION:
			title = @"General Information";
			break;
        default:
            break;
    }
    return title;;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    switch (section) {
        case LOCATION_SECTION:
			if([addressText length] > 0)
				rows++;
			if (displayedResource.phone != nil && [displayedResource.phone length] > 0)
				rows++;
			if (displayedResource.url != nil && [displayedResource.url length] > 0)
				rows++;
            return rows;
        case DETAILS_SECTION:
            rows = 1;
            break;
		case SERVICES_SECTION:
			if ([displayedResource services] != nil) {
				for (CPMService* service in [[displayedResource services] objectForKey:@"primary"]) {
					// Skip the 'Y' service code tree
					if (![[service code] hasPrefix:@"Y"]) {
						rows++;
					}
				}
			}
			break;
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
			if ([[displayedResource shelterFlag] boolValue]) {
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


- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	static NSString *ResourceDetailCellIdentifier = @"ResourceDetailCell";
	static NSString *ResourceLocationCellIdentifier = @"ResourceLocationCell";
	static NSString *ResourceActionCellIdentifier = @"ResourceActionCell";
	static NSString *ResourceServiceCellIdentifier = @"ResourceServiceCell";
	static NSString *ResourceGeneralCellIdentifier = @"ResourceGeneralCell";
	
	UITableViewCell *cell = nil;
	if (indexPath.section == LOCATION_SECTION) {
		
		
		NSUInteger row = [indexPath row];
		
		switch (row) {
			case 0:
				if([addressText length] > 0){
					cell = [tableView dequeueReusableCellWithIdentifier:ResourceLocationCellIdentifier];
					if(cell == nil){
						cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ResourceLocationCellIdentifier];
					}
					
					
					cell.textLabel.text = @"address";
					cell.detailTextLabel.text = addressText;
					cell.detailTextLabel.numberOfLines = 0;
					cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
					addressCellIndex = row;
					return cell;
				}

			case 1:
				if([addressText length] > 0 && displayedResource.phone != nil && [displayedResource.phone length] > 0) {
					cell = [tableView dequeueReusableCellWithIdentifier:ResourceLocationCellIdentifier];
					if(cell == nil){
						cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ResourceLocationCellIdentifier];
					}
					
					cell.textLabel.text = @"phone";
					cell.detailTextLabel.text = [displayedResource phone];
					phoneCellIndex = row;
					return cell;
				} 
			case 2:
				if(displayedResource.url != nil && [displayedResource.url length] > 0) {
					cell = [tableView dequeueReusableCellWithIdentifier:ResourceActionCellIdentifier];
					if(cell == nil){
						cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceActionCellIdentifier];
					}
					
					cell.textLabel.text = @"Website";
					cell.textLabel.textAlignment = UITextAlignmentCenter;
					cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:0.25098 blue:0.501961 alpha:1.0];
					urlCellIndex = row;
					return cell;
				}
		}
	} else if (indexPath.section == DETAILS_SECTION) {
		NSUInteger row = [indexPath row];
		
		switch (row) {
			case 0:
				{
					cell = [tableView dequeueReusableCellWithIdentifier:ResourceDetailCellIdentifier];
					if(cell == nil){
						cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceDetailCellIdentifier];
					}
					
					cell.textLabel.text = [displayedResource description];
					cell.textLabel.numberOfLines = 0;
					cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
					cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;

				}
				break;
		}
	} else if (indexPath.section == SERVICES_SECTION) {
        NSUInteger row = [indexPath row];
		
		int currentIndex = 0;
		for (CPMService* service in [[displayedResource services] objectForKey:@"primary"]) {
			// Skip the 'Y' service code tree
			if (![[service code] hasPrefix:@"Y"]) {
				if (currentIndex == row) {
					cell = [tableView dequeueReusableCellWithIdentifier:ResourceServiceCellIdentifier];
					if(cell == nil){
						cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceServiceCellIdentifier];
					}
					
					cell.textLabel.text = [service name];
					cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					
					break;
				}
			}
			currentIndex++;
		}
	} else if (indexPath.section == GENERAL_SECTION) {
		NSUInteger row = [indexPath row];
		
		cell = [tableView dequeueReusableCellWithIdentifier:ResourceGeneralCellIdentifier];
		if(cell == nil){
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ResourceGeneralCellIdentifier];
		}
		
		if (row == hoursCellIndex) {
			cell.textLabel.text = @"hours";
			cell.detailTextLabel.text = [displayedResource hours];
		} else if (row == programFeesCellIndex) {
			cell.textLabel.text = @"program fees";
			cell.detailTextLabel.text = [displayedResource programFees];
		} else if (row == languagesCellIndex) {
			cell.textLabel.text = @"languages";
			cell.detailTextLabel.text = [displayedResource languages];
		} else if (row == eligibilityCellIndex) {
			cell.textLabel.text = @"eligibility";
			cell.detailTextLabel.text = [displayedResource eligibility];
		} else if (row == intakeProcedureCellIndex) {
			cell.textLabel.text = @"intake process";
			cell.detailTextLabel.text = [displayedResource intakeProcedure];
		} else if (row == accessibilityCellIndex) {
			cell.textLabel.text = @"handicap accessible";
			cell.detailTextLabel.text = @"Yes";
		} else if (row == shelterCellIndex) {
			cell.textLabel.text = @"shelter";
			cell.detailTextLabel.text = @"Yes";
		} else if (row == shelterRequirementsCellIndex) {
			cell.textLabel.text = @"shelter requirements";
			cell.detailTextLabel.text = [displayedResource shelterRequirements];
		}
		
		cell.textLabel.adjustsFontSizeToFitWidth = YES;
		cell.textLabel.numberOfLines = 0;
		cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
		cell.detailTextLabel.numberOfLines = 0;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([indexPath section] == DETAILS_SECTION && [indexPath row] == 0){
		NSString *cellText =[displayedResource description];
		UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
		CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
		CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
		return labelSize.height + 20;
	} else if ([indexPath section] == LOCATION_SECTION && [indexPath row] == 0) {
		NSString *cellText = addressText;
		UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:19.0];
		CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
		CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		
		return labelSize.height + 20;
	} else if ([indexPath section] == GENERAL_SECTION) { 
		NSUInteger row = [indexPath row];

		NSString *cellText;
		
		if (row == hoursCellIndex) {
			cellText = [displayedResource hours];
		} else if (row == programFeesCellIndex) {
			cellText = [displayedResource programFees];
		} else if (row == languagesCellIndex) {
			cellText = [displayedResource languages];
		} else if (row == eligibilityCellIndex) {
			cellText = [displayedResource eligibility];
		} else if (row == intakeProcedureCellIndex) {
			cellText = [displayedResource intakeProcedure];
		} else if (row == accessibilityCellIndex) {
			cellText = @"Yes";
		} else if (row == shelterCellIndex) {
			cellText = @"Yes";
		} else if (row == shelterRequirementsCellIndex) {
			cellText = [displayedResource shelterRequirements];
		}

		UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:19.0];
		CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
		CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		
		return labelSize.height + 20;
    } else {
		return 44;
	}
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == LOCATION_SECTION) {
		if(indexPath.section == LOCATION_SECTION && indexPath.row == urlCellIndex){
			NSString *url = [displayedResource url];
			if(![[displayedResource url] hasPrefix: @"http://"]){
				url = [NSString stringWithFormat:@"http://%@", [displayedResource url]];
			}
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
		} else if (indexPath.section == LOCATION_SECTION && indexPath.row == phoneCellIndex) {
			NSString *urlString = [NSString stringWithFormat:@"tel:%@%@%@", [[displayedResource primaryPhone] areaCode], [[displayedResource primaryPhone] prefix], [[displayedResource primaryPhone] line]];
			NSURL *url = [NSURL URLWithString:urlString];
			if ([[UIApplication sharedApplication] canOpenURL:url]) {
				[[UIApplication sharedApplication] openURL:url];
			}
		} else if(indexPath.section == LOCATION_SECTION && indexPath.row == addressCellIndex) {
			if(displayedResource.latitude != nil) {
				ResourceMapViewController *mapViewController = [[ResourceMapViewController alloc] initWithNibName:@"ResourceMapViewController" bundle:[NSBundle mainBundle]];

				[self.navigationController pushViewController:mapViewController animated:YES];
				mapViewController.displayedResource = displayedResource;
		
				[mapViewController release];
			}
		}
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
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
