//
//  Util.c
//  CommunityPointMobile
//
//  Created by John Cannon on 6/14/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "Util.h"

id nullFix(id value) {
	if((NSNull*)value == [NSNull null])
		return nil;
	else
		return value;
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
	
	// TODO: Phone
	
	[email appendString:@"</div>"];
	
	// TODO: Link
	
	// Description
	[email appendString:@"<div style=\"padding: 0; margin: 0 0 20px 0;\">"];
	[email appendString:@"<p style=\"font-family: 'Arial', Helvetica, sans-seriff; font-size: 1.1em; font-weight: bold; padding: 0; margin: 0 0 5px 0; color: #333;\">Description:</p>"];
	[email appendFormat:@"<p style=\"font-family: 'Arial', Helvetica, sans-seriff; font-size: 1.0em; padding: 0; margin: 0; color: #333;\">%@</p></div>", [resource description]];

	// TODO: Service Codes
	
	[email appendString:@"</body></html>"];
	
	[email autorelease];

	return email;
}