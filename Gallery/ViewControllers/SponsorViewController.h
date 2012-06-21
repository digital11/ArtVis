//
//  SponsorViewController.h
//  Gallery
//
//  Created by Chris Bower on 6/18/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SponsorViewController : UIViewController
@property (retain, nonatomic) NSDictionary *sponsor;
@property (retain, nonatomic) IBOutlet UILabel *sponsorTitle;
@property (retain, nonatomic) IBOutlet UILabel *description;
@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (retain, nonatomic) IBOutlet UIScrollView *scroller;
@property (retain, nonatomic) IBOutlet UIView *background;

@end
