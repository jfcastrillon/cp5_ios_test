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
#import "DescriptionTextViewCell.h"
#import "Util.h"


#define DETAILS_SECTION 1
#define LOCATION_SECTION 0
#define ACTION_SECTION 2

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

- (IBAction) favoriteButtonPressed: (id) sender {
	[xsHelper addResourceToFavorites: displayedResource]; 
	[self updateDisplay];
}

- (IBAction) shareButtonPressed: (id) sender {
	UIActionSheet *shareTypeSheet = [[UIActionSheet alloc] initWithTitle:@"Share Resource Using:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
													   otherButtonTitles:@"Email", @"SMS", nil, nil];
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
			[shareButton setFrame:CGRectMake(10, 0, 302, 37)];
		} 
		// Otherwise, show the "Add to Favorites" button
		else {
			[favoriteButton setHidden: NO];
			[shareButton setFrame:CGRectMake(10, 0, 142, 37)];
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
		return 2;
	}
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    // Return a title or nil as appropriate for the section.
    switch (section) {
        case LOCATION_SECTION:
            //title = @"Location";
            break;
        case DETAILS_SECTION:
            title = @"Description";
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
		case ACTION_SECTION:
			rows = 2;
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
					return cell;
				}
		}
	} else if (indexPath.section == DETAILS_SECTION) {
		
		NSUInteger row = [indexPath row];
		
		switch (row) {
			case 0:
				{
					
					/*DescriptionTextViewCell *tvCell = [DescriptionTextViewCell createFromNib];
					tvCell.textView.text = [displayedResource description];
					cell = tvCell;*/
					
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
	} else { // ACTION SECTION
        
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
	} else {
		return 44;
	}
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == LOCATION_SECTION && indexPath.row == 2){
		 [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [displayedResource url]]];
	} else if(indexPath.section == LOCATION_SECTION && indexPath.row == 0) {
		if(displayedResource.latitude != nil) {
			ResourceMapViewController *mapViewController = [[ResourceMapViewController alloc] initWithNibName:@"ResourceMapViewController" bundle:[NSBundle mainBundle]];

			[self.navigationController pushViewController:mapViewController animated:YES];
			mapViewController.displayedResource = displayedResource;
		
			[mapViewController release];
		}
	}
}

// Share Resource
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case SHARE_EMAIL_BUTTON:
			[self emailResource];
			break;
		case SHARE_SMS_BUTTON:
			[self smsResource];
			break;
		default:
			// They picked cancel
			return;
	}
}

// SMS a Resource
- (void)smsResource {
    // The MFMessageComposeViewController class is only available in iPhone OS 4.0 or later. 
    // So, we must verify the existence of the above class and provide a workaround for devices running 
    // earlier versions of the iPhone OS. 
    // We display an sms composition interface if MFMessageComposeViewController exists and the device can send sms.
    
    Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (smsClass != nil)
    {
        // We must always check whether the current device is configured for sending sms
        if ([smsClass canSendText])
        {
			[self displaySmsSheet];
		}
		else 
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SMS Not Supported" message:@"You tried to SMS a Resource.  Unfortunately this isn't supported on your device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
			[alert show]; 
			[alert release]; 
		}
	}
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SMS Not Supported" message:@"You tried to SMS a Resource.  Unfortunately this isn't supported on your device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
	}
}

// Launch the SMS Compose Message Controller.
- (void)displaySmsSheet {
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
