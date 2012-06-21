//
//  HomeViewContoller.h
//  Gallery
//
//  Created by Chris Bower on 5/21/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeaturedGridViewController.h"

@interface HomeViewContoller : UIViewController<UITextFieldDelegate> {
    UIViewController *_activeController;
    UIPopoverController *_popover;
    FeaturedGridViewController *_featured;
    BOOL _inited;
    BOOL _keyboardIsShown;
    int _sponsorIndex;
    NSTimer *_sponsorTimer;
}
@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UIButton *btnFeatured;
@property (retain, nonatomic) IBOutlet UIButton *btnGenre;
@property (retain, nonatomic) IBOutlet UIButton *btnSubject;
@property (retain, nonatomic) IBOutlet UIButton *btnArtist;
@property (retain, nonatomic) IBOutlet UIButton *btnAll;
@property (retain, nonatomic) IBOutlet UIView *trayView;
- (IBAction)showFeatured:(id)sender;
- (IBAction)showAll:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *sponsorImage;
@property (retain, nonatomic) IBOutlet UILabel *sponsorTitle;
@property (retain, nonatomic) IBOutlet UILabel *sponsorLine;
@property (retain, nonatomic) IBOutlet UIView *sponsorView;

@end
