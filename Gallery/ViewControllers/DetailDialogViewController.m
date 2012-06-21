//
//  DetailDialogViewController.m
//  Gallery
//
//  Created by Chris Bower on 5/23/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import "DetailDialogViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "FullViewController.h"
#import "SizesDataSource.h"
#import "DataSelectorViewController.h"

@interface DetailDialogViewController ()

@end

@implementation DetailDialogViewController
@synthesize art = _art;
@synthesize background = _background;
@synthesize dialog = _dialog;
@synthesize image = _image;
@synthesize scroller = _scroller;
@synthesize artistLabel = _artistLabel;
@synthesize artistText = _artistText;
@synthesize bioLabel = _bioLabel;
@synthesize bioText = _bioText;
@synthesize pieceLabel = _pieceLabel;
@synthesize pieceText = _pieceText;
@synthesize sizeLabel = _sizeLabel;
@synthesize viewSize1 = _viewSize1;
@synthesize viewSize2 = _viewSize2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"full"]) {
        FullViewController *full = (FullViewController *)[segue destinationViewController];
        full.art = _art;
        //[full populate:_art];
        [(UINavigationController *)[[AppDelegate sharedAppDelegate] window].rootViewController pushViewController:full animated:YES];
    } else if ([[segue identifier] isEqualToString:@"size"]) {
        [(DataSelectorViewController *)segue.destinationViewController setDataSource:[[[SizesDataSource alloc] init:[_art objectForKey:@"sizes"]] autorelease]];
//        UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
//        _popover = popoverSegue.popoverController;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    tap.cancelsTouchesInView = NO;
    [_background addGestureRecognizer:tap];
    [tap release];
}
- (void)close {
    [AppDelegate hideFullTv];
    [UIView animateWithDuration:.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self viewDidUnload];
        [self release];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailClosed" object:nil];
    }];

}
- (void)viewDidUnload
{
    [self setArt:nil];
    [self setBackground:nil];
    [self setDialog:nil];
    [self setImage:nil];
    [self setScroller:nil];
    [self setArtistLabel:nil];
    [self setArtistText:nil];
    [self setBioLabel:nil];
    [self setBioText:nil];
    [self setPieceLabel:nil];
    [self setPieceText:nil];
    [self setSizeLabel:nil];
    [self setViewSize1:nil];
    [self setViewSize2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)dealloc {
    [_art release];
    [_background release];
    [_dialog release];
    [_image release];
    [_scroller release];
    [_artistLabel release];
    [_artistText release];
    [_bioLabel release];
    [_bioText release];
    [_pieceLabel release];
    [_pieceText release];
    [_sizeLabel release];
    [_viewSize1 release];
    [_viewSize2 release];
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated {

    
    [self populate:self.art];
    if (YES) {
        self.view.alpha = 0;
        [UIView animateWithDuration:.3 animations:^{
            self.view.alpha = 1; 
        }];
    }
}
- (void)populate:(NSDictionary *)art {
    self.art = art;
    
    [AppDelegate showFullTv:art];
    CGRect frame;
    [_image setImageWithURL:[NSURL URLWithString:[art objectForKey:@"small"]]];
    
    _image.contentMode = UIViewContentModeScaleAspectFill;
    _image.clipsToBounds = YES;
    NSDictionary *artist = [AppDelegate getArtist:[[art objectForKey:@"artistId"] intValue]];
    
    _artistText.text = [artist objectForKey:@"title"];
    _artistText.numberOfLines = 0;
    frame = _artistText.frame;
    frame.size.height = 0;
    _artistText.frame = frame;
    [_artistText sizeToFit];
    
    
    frame = _bioLabel.frame;
    frame.origin.y = _artistText.frame.size.height + _artistText.frame.origin.y + 15;
    _bioLabel.frame = frame;
    _bioText.text = [artist objectForKey:@"bio"];
    frame = _bioText.frame;
    frame.size.height = 0;
    frame.origin.y = _bioLabel.frame.origin.y + _bioLabel.frame.size.height + 5;
    _bioText.frame = frame;
    _bioText.numberOfLines = 0;
    [_bioText sizeToFit];
    
    frame = _pieceLabel.frame;
    frame.origin.y = _bioText.frame.size.height + _bioText.frame.origin.y + 15;
    _pieceLabel.frame = frame;
    _pieceText.text = [art objectForKey:@"description"];
    frame = _pieceText.frame;
    frame.size.height = 0;
    frame.origin.y = _pieceLabel.frame.origin.y + _pieceLabel.frame.size.height + 5;
    _pieceText.frame = frame;
    _pieceText.numberOfLines = 0;
    [_pieceText sizeToFit];
    
    
    frame = _sizeLabel.frame;
    frame.origin.y = _pieceText.frame.size.height + _pieceText.frame.origin.y + 15;
    _sizeLabel.frame = frame;
    
    frame = _viewSize1.frame;
    frame.origin.y = _sizeLabel.frame.origin.y + _sizeLabel.frame.size.height + 5;
    _viewSize1.frame = frame;
    frame = _viewSize2.frame;
    frame.origin.y = _sizeLabel.frame.origin.y + _sizeLabel.frame.size.height + 5;
    _viewSize2.frame = frame;
    
    [_scroller setContentSize:CGSizeMake(_scroller.frame.size.width, _viewSize1.frame.origin.y + _viewSize1.frame.size.height + 15)];
}
@end
