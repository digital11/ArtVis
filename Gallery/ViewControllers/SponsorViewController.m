//
//  SponsorViewController.m
//  Gallery
//
//  Created by Chris Bower on 6/18/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import "SponsorViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"

@interface SponsorViewController ()

@end

@implementation SponsorViewController
@synthesize sponsor;
@synthesize sponsorTitle;
@synthesize description;
@synthesize image;
@synthesize scroller;
@synthesize background;

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    tap.cancelsTouchesInView = NO;
    [background addGestureRecognizer:tap];
    [tap release];

}

- (void)viewDidUnload
{
    [self setSponsorTitle:nil];
    [self setDescription:nil];
    [self setImage:nil];
    [self setScroller:nil];
    [self setBackground:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)dealloc {
    [sponsor release];
    [sponsorTitle release];
    [description release];
    [image release];
    [scroller release];
    [background release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [self populate:self.sponsor];
    if (YES) {
        self.view.alpha = 0;
        [UIView animateWithDuration:.3 animations:^{
            self.view.alpha = 1; 
        }];
    }
}
- (void)populate:(NSDictionary *)data {
    self.sponsor = data;
    
    [image setImageWithURL:[NSURL URLWithString:[data objectForKey:@"image"]]];
    
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.clipsToBounds = YES;
    sponsorTitle.text = [data objectForKey:@"title"];
    description.text = [data objectForKey:@"description"];
    description.numberOfLines = 0;
    [description sizeToFit];
    
    
    [scroller setContentSize:CGSizeMake(scroller.frame.size.width, description.frame.size.height + description.frame.origin.y + 15)];
}
- (void)close {
    [UIView animateWithDuration:.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self viewDidUnload];
        [self release];
    }];
    
}
@end
