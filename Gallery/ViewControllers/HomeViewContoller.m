//
//  HomeViewContoller.m
//  Gallery
//
//  Created by Chris Bower on 5/21/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import "HomeViewContoller.h"

@interface HomeViewContoller ()

@end

@implementation HomeViewContoller

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
	return YES;
}

@end