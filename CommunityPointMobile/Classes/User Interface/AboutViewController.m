//
//  AboutViewController.m
//  CommunityPointMobile
//
//  Created by John Cannon on 7/29/10.
//  Copyright 2010 Bowman Systems, LLC. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController
@synthesize delegate;
@synthesize aboutHtmlView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
	[aboutHtmlView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"]isDirectory:NO]]];
	[super viewWillAppear: animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.aboutHtmlView = nil;
	self.delegate = nil;
}


- (void)dealloc {
	[aboutHtmlView release];
    [super dealloc];
}

- (IBAction) dismiss {
	[self.delegate aboutViewShouldDismiss];
}


@end
