//
//  Util.c
//  CommunityPointMobile
//
//  Created by John Cannon on 6/14/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "Util.h"
#import "CPMService.h"

id nullFix(id value) {
	if((NSNull*)value == [NSNull null])
		return nil;
	else
		return value;
}

NSString* buildSMS(CPMResourceDetail* resource) {
	NSMutableString* sms = [[NSMutableString alloc] initWithFormat:@"%@\n\n", [resource name]];
	if ([resource phone] != nil && [[resource phone] length] > 0) {
		[sms appendFormat:@"%@; ", [resource phone]];
	}
	if ([resource address1] != nil && [[resource address1] length] > 0) {
		[sms appendFormat:@"%@, ", [resource address1]];
	}
	if ([resource city] != nil && [[resource city] length] > 0) {
		[sms appendFormat:@"%@, ", [resource city]];
	}
	if ([resource state] != nil && [[resource state] length] > 0) {
		[sms appendFormat:@"%@ ", [resource state]];
	}
	if ([resource zipcode] != nil && [[resource zipcode] length] > 0) {
		[sms appendFormat:@"%@\n", [resource zipcode]];
	}

	[sms autorelease];
	
	return sms;
}

NSString* buildEmail(CPMResourceDetail* resource) {
	NSMutableString* email = [[NSMutableString alloc] initWithString:@"<html><head><title>"];
	[email appendFormat: @"%@</title></head><body>", [resource name]];
	[email appendFormat:@"<h1 style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 1.6em; font-weight: bold; padding: 15px 0 0 0; line-height: 1.0em;\">%@</h1>", [resource name]];
	
	// Address
	[email appendString:@"<div style=\"padding: 0; margin: 0 0 15px 0;\"><p style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 1.2em; padding: 0; margin: 0;\">"];
	if ([resource address1] != nil && [[resource address1] length] > 0) {
		[email appendFormat:@"%@", [resource address1]];
	}
	[email appendString:@"</p><p style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 1.2em; padding: 0; margin: 0;\">"];
	if ([resource address2] != nil && [[resource address2] length] > 0) {
		[email appendFormat:@"%@", [resource address2]];
	}
	[email appendFormat:@"<p style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 1.2em; padding: 0; margin: 0;\">%@ %@ %@</p>", [resource city], [resource state], [resource zipcode]];
	
	// Phone
	if ([resource phone] != nil) {
		[email appendFormat:@"<p style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 1.2em; padding: 0; margin: 0;\">%@</p>", [resource phone]];
	}
	
	[email appendString:@"</div>"];
	
	// Link
	[email appendFormat:@"<p style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 1.2em; padding: 0; margin: 0 0 20px 0;\"><a href=\"%@\" style=\"color: #339933;\">%@</a></p>", [resource url], [resource url]];
	
	// Description
	[email appendString:@"<div style=\"padding: 0; margin: 0 0 20px 0;\">"];
	[email appendString:@"<p style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 1.1em; font-weight: bold; padding: 0; margin: 0 0 5px 0; color: #333;\">Description:</p>"];
	[email appendFormat:@"<p style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 1.0em; padding: 0; margin: 0; color: #333;\">%@</p></div>", [resource description]];

	// Service Codes
	[email appendString:@"<div style=\"padding: 0; margin: 0 0 20px 0;\">"];
	[email appendString:@"<p style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 1.1em; font-weight: bold; padding: 0; margin: 0 0 5px 0; color: #333;\">Primary Services Offered:</p>"];
	[email appendString:@"<div style=\"padding: 0; margin: 0 0 0 20px;\">"];
	for (CPMService* service in [[resource services] objectForKey:@"primary"]) {
		// Skip the 'Y' service code tree
		if (![[service code] hasPrefix:@"Y"]) {
			[email appendFormat:@"<p style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0; margin: 0; color: #333;\">%@</p>", [service name]];
		}
	}
	[email appendString:@"</div></div>"];
	
	// General information
	[email appendString:@"<div style=\"padding: 0; margin: 0 0 20px 0;\">"];
	[email appendString:@"<p style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 1.1em; font-weight: bold; padding: 0; margin: 0 0 5px 0; color: #333;\">General Information:</p>"];
	[email appendString:@"<div style=\"padding: 0; margin: 0 0 0 20px;\">"];
	[email appendString:@"<table style=\"width: 100%; border-collapse: collapse; border-spacing: 0; padding: 0; margin: 0;\" cellpadding=\"0\" cellspacing=\"0\">"];
	
	// Hours
	if ([resource hours] != nil && [[resource hours] length] > 0) {
		[email appendString:@"<tr><td style=\"width: 140px; font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0; margin: 0; color: #333; vertical-align: top;\">Hours</td>"];
		[email appendFormat:@"<td style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0 0 5px 0; margin: 0; color: #333;\">%@</td></tr>", [resource hours]];
	}
	
	// Program Fees
	if ([resource programFees] != nil && [[resource programFees] length] > 0) {
		[email appendString:@"<tr><td style=\"width: 140px; font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0; margin: 0; color: #333; vertical-align: top;\">Program Fees</td>"];
		[email appendFormat:@"<td style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0 0 5px 0; margin: 0; color: #333;\">%@</td></tr>", [resource programFees]];
	}
	
	// Languages
	if ([resource languages] != nil && [[resource languages] length] > 0) {
		[email appendString:@"<tr><td style=\"width: 140px; font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0; margin: 0; color: #333; vertical-align: top;\">Languages</td>"];
		[email appendFormat:@"<td style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0 0 5px 0; margin: 0; color: #333;\">%@</td></tr>", [resource languages]];
	}
	
	// Eligibility
	if ([resource eligibility] != nil && [[resource eligibility] length] > 0) {
		[email appendString:@"<tr><td style=\"width: 140px; font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0; margin: 0; color: #333; vertical-align: top;\">Eligibility</td>"];
		[email appendFormat:@"<td style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0 0 5px 0; margin: 0; color: #333;\">%@</td></tr>", [resource eligibility]];
	}
	
	// Intake Procedure
	if ([resource intakeProcedure] != nil && [[resource intakeProcedure] length] > 0) {
		[email appendString:@"<tr><td style=\"width: 140px; font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0; margin: 0; color: #333; vertical-align: top;\">Intake Process</td>"];
		[email appendFormat:@"<td style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0 0 5px 0; margin: 0; color: #333;\">%@</td></tr>", [resource intakeProcedure]];
	}
	
	// Handicap Accessible?
	if ([[resource accessibilityFlag] boolValue]) {
		[email appendString:@"<tr><td style=\"width: 140px; font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0; margin: 0; color: #333; vertical-align: top;\">Handicap Accessible?</td>"];
		[email appendString:@"<td style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0 0 5px 0; margin: 0; color: #333;\">Yes</td></tr>"];
	}
	
	// Shelter?
	if ([[resource isShelter] boolValue]) {
		[email appendString:@"<tr><td style=\"width: 140px; font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0; margin: 0; color: #333; vertical-align: top;\">Shelter?</td>"];
		[email appendString:@"<td style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0 0 5px 0; margin: 0; color: #333;\">Yes</td></tr>"];
		
		// Shelter Requirements
		if ([resource shelterRequirements] != nil && [[resource shelterRequirements] length] > 0) {
			[email appendString:@"<tr><td style=\"width: 140px; font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0; margin: 0; color: #333; vertical-align: top;\">Shelter Requirements</td>"];
			[email appendFormat:@"<td style=\"font-family: 'Arial', Helvetica, sans-serif; font-size: 0.9em; padding: 0 0 5px 0; margin: 0; color: #333;\">%@</td></tr>", [resource shelterRequirements]];
		}
	}
	
	[email appendString:@"</table></div></div>"];
	
	[email appendString:@"</body></html>"];
	
	[email autorelease];

	return email;
}