//
//  OrientationPickerViewController.m
//  Gallery
//
//  Created by Chris Bower on 6/22/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import "OrientationPickerViewController.h"
#import "AppDelegate.h"
@interface OrientationPickerViewController ()

@end

@implementation OrientationPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)landscape:(id)sender {
    [[AppDelegate sharedAppDelegate] showTv:NO];
    [self.view removeFromSuperview];
}

- (IBAction)portrait:(id)sender {
    [[AppDelegate sharedAppDelegate] showTv:YES];
    [self.view removeFromSuperview];
}
@end
