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


#define DETAILS_SECTION 1
#define LOCATION_SECTION 0
#define ACTION_SECTION 2

@implementation ResourceDetailViewController


@synthesize nameLabel, tableView;


@dynamic displayedResource;

- (CPMResourceDetail*) displayedResource {
	return displayedResource;
}

- (void) setDisplayedResource:(CPMResourceDetail*) newResource{
	if(newResource != displayedResource){
		[displayedResource release];
		displayedResource = newResource;
		
		//Build address line
		NSMutableString *addressLine = [[NSMutableString alloc] init];
		NSMutableArray *addressParts = [[NSMutableArray alloc] init];
		
		if([displayedResource address1] != nil &&
		   [[displayedResource address1] length] > 0)
			[addressLine appendFormat: @"%@\n", [displayedResource address1]];
		if([displayedResource address2] != nil &&
		   [[displayedResource address2] length] > 0)
			[addressLine appendFormat: @"%@\n", [displayedResource address2]];
		
		if(displayedResource.city != nil)
			[addressParts addObject: [displayedResource city]];
		if(displayedResource.state != nil)	
			[addressParts addObject: [displayedResource state]];
		if(displayedResource.zipcode != nil)	
			[addressParts addObject: [[displayedResource zipcode] stringValue]];
		
		for(int i = 0; i < [addressParts count]; i++) {
			NSString* part = [addressParts objectAtIndex:i];
			if(part != nil) {
				part = [part stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
				if([part length] > 0) {
					[addressLine appendString: part];
					if(i+1 < [addressParts count])
						[addressLine appendString: @", "];
				}
			}
		}
		
		[addressText release];
		addressText = addressLine;
		[addressText retain];
		[addressParts release];
		
		[displayedResource retain];
		[self updateDisplay];
	}
}

- (IBAction) favoriteButtonPressed: (id) sender {
	// TODO: Implement favorites
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favorite Performed" message:@"You tried to add a favorite.  Unfortunately this isn't implemented yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (IBAction) emailButtonPressed: (id) sender {
	MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
	mail.modalPresentationStyle = UIModalPresentationPageSheet;
	mail.mailComposeDelegate = self;
	
	[mail setSubject:@"CommunityPoint Mobile Resource Information"];
	
	NSString *emailBody = [NSString stringWithFormat:@"<b>%@</b><br /><br /><b>Address:</b> %@<br /><b>Phone:</b><br />", 
						   [displayedResource name], addressText, [displayedResource phone]];
    [mail setMessageBody:emailBody isHTML:YES];
	
	[self presentModalViewController:mail animated:YES];
	[mail release];				 
}

- (void) updateDisplay {
	nameLabel.text = displayedResource.name;
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
}


- (void)dealloc {
	[displayedResource release];
	[addressText release];
	[nameLabel release];
	[tableView release];
    [super dealloc];
}
	 
// Email resource
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
	 
//Table data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
				}
				break;
			case 1:
				if([addressText length] > 0 && displayedResource.phone != nil && [displayedResource.phone length] > 0) {
					cell = [tableView dequeueReusableCellWithIdentifier:ResourceLocationCellIdentifier];
					if(cell == nil){
						cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ResourceLocationCellIdentifier];
					}
					
					cell.textLabel.text = @"phone";
					cell.detailTextLabel.text = [displayedResource phone];
				}
				break;
			case 2:
				if(displayedResource.url != nil && [displayedResource.url length] > 0) {
					cell = [tableView dequeueReusableCellWithIdentifier:ResourceActionCellIdentifier];
					if(cell == nil){
						cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResourceActionCellIdentifier];
					}
					
					cell.textLabel.text = @"Website";
					cell.textLabel.textAlignment = UITextAlignmentCenter;
					cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:0.25098 blue:0.501961 alpha:1.0];
				}
				break;
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


@end
