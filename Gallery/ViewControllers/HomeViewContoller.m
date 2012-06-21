//
//  HomeViewContoller.m
//  Gallery
//
//  Created by Chris Bower on 5/21/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import "HomeViewContoller.h"
#import "AFJSONRequestOperation.h"
#import "UIImageView+AFNetworking.h"
#import "ArtView.h"
#import "DetailDialogViewController.h"
#import "AppDelegate.h"
#import "ArtistDataSource.h"
#import "DataSelectorViewController.h"
#import "PagingGridViewController.h"
#import "CategoryDataSource.h"
#import "GenreDataSource.h"
#import <QuartzCore/QuartzCore.h>
#import "SponsorViewController.h"

@interface HomeViewContoller ()

@end

@implementation HomeViewContoller
@synthesize sponsorImage = _sponsorImage;
@synthesize sponsorTitle = _sponsorTitle;
@synthesize sponsorLine = _sponsorLine;
@synthesize sponsorView = _sponsorView;
@synthesize mainView = _mainView;
@synthesize btnFeatured = _btnFeatured;
@synthesize btnGenre = _btnGenre;
@synthesize btnSubject = _btnSubject;
@synthesize btnArtist = _btnArtist;
@synthesize btnAll = _btnAll;
@synthesize trayView = _trayView;


- (void)performQuery:(NSDictionary *)query {
    _activeController = [[[PagingGridViewController alloc] initWithFrame:CGRectMake(0, 0, _mainView.frame.size.width, _mainView.frame.size.height) andQuery:query] retain];
    [_mainView addSubview:_activeController.view];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"artist"]) {
        [(DataSelectorViewController *)segue.destinationViewController setDataSource:[[[ArtistDataSource alloc] init] autorelease]];
        UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
        _popover = popoverSegue.popoverController;
    } else if ([[segue identifier] isEqualToString:@"subject"]) {
        [(DataSelectorViewController *)segue.destinationViewController setDataSource:[[[CategoryDataSource alloc] init] autorelease]];
        UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
        _popover = popoverSegue.popoverController;

        
    } else if ([[segue identifier] isEqualToString:@"genre"]) {
        [(DataSelectorViewController *)segue.destinationViewController setDataSource:[[[GenreDataSource alloc] init] autorelease]];
        UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
        _popover = popoverSegue.popoverController;
        
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:self.view.window];
    _keyboardIsShown = NO;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sponsorTap:)];
    [_sponsorView addGestureRecognizer:tap];
    [tap release];
    _sponsorImage.userInteractionEnabled = YES;
    
}
- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* info = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    float h = keyboardSize.height;
    if (h > keyboardSize.width)
        h = keyboardSize.width;
    // resize the scrollview
    CGRect viewFrame = self.trayView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.origin.y += (h);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    // The kKeyboardAnimationDuration I am using is 0.3
    [UIView setAnimationDuration:.3];
    [self.trayView setFrame:viewFrame];
    [UIView commitAnimations];
    
    _keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the UIScrollView if the keyboard is already shown.  This can happen if the user, after fixing editing a UITextField, scrolls the resized UIScrollView to another UITextField and attempts to edit the next UITextField.  If we were to resize the UIScrollView again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (_keyboardIsShown) {
        return;
    }
    
    NSDictionary* info = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.trayView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    float h = keyboardSize.height;
    if (h > keyboardSize.width)
        h = keyboardSize.width;
    viewFrame.origin.y -= (h);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    // The kKeyboardAnimationDuration I am using is 0.3
    [UIView setAnimationDuration:.3];
    [self.trayView setFrame:viewFrame];
    [UIView commitAnimations];
    
    _keyboardIsShown = YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    
    _btnFeatured.selected = _btnGenre.selected = _btnAll.selected = _btnSubject.selected = _btnArtist.selected = NO;
    _btnAll.selected = YES;
    
    NSDictionary *query = [NSDictionary dictionaryWithObject:textField.text forKey:@"s"];
    if (_activeController == _featured) {
        [UIView animateWithDuration:.3 animations:^{
            _featured.view.alpha = 0; 
        } completion:^(BOOL finished) {            
            [self performSelectorOnMainThread:@selector(performQuery:) withObject:query waitUntilDone:NO];
        }];
    } else {
        [UIView animateWithDuration:.3 animations:^{
            _activeController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [_activeController.view removeFromSuperview];
            [_activeController release];
            [self performSelectorOnMainThread:@selector(performQuery:) withObject:query waitUntilDone:NO];
        }];
    }

    
    return NO;
}
- (void)viewDidUnload
{
    [_activeController viewDidUnload];
    [self setMainView:nil];
    [self setBtnFeatured:nil];
    [self setBtnGenre:nil];
    [self setBtnSubject:nil];
    [self setBtnArtist:nil];
    [self setBtnAll:nil];
    [self setTrayView:nil];
    [self setSponsorImage:nil];
    [self setSponsorTitle:nil];
    [self setSponsorLine:nil];
    [self setSponsorView:nil];
        [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)viewDidAppear:(BOOL)animated {
    if (!_inited) {
        _inited = YES;
        _sponsorIndex = 0;
        [self populateSponsor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectArtist:) name:@"selectedArtist" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCategory:) name:@"selectedCategory" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectGenre:) name:@"selectedGenre" object:nil];
        _featured = [[[FeaturedGridViewController alloc] initWithFrame:CGRectMake(0, 0, _mainView.frame.size.width, _mainView.frame.size.height)] retain];
        [_mainView addSubview:_featured.view];

        _activeController = _featured;
        
        _sponsorTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(advanceSponsor) userInfo:nil repeats:YES];
    }
}
- (void)advanceSponsor {
    
    UIGraphicsBeginImageContextWithOptions(_sponsorView.frame.size,NO,0.0f);
    [_sponsorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *iv = [[UIImageView alloc] initWithImage:viewImage];
    UIGraphicsEndImageContext();
    iv.tag = 999;
    [_sponsorView addSubview:iv];
    [iv release];
    
    _sponsorIndex++;
    [self populateSponsor];
    [UIView animateWithDuration:1 animations:^{
        iv.alpha = 0; 
    } completion:^(BOOL finished) {
        [iv removeFromSuperview];
    }];
    
}
- (void)populateSponsor {
    if ([[[AppDelegate sharedAppDelegate] sponsors] count] == 0) {

        return;
    }
    if ([[[AppDelegate sharedAppDelegate] sponsors] count] - 1 < _sponsorIndex) {
        _sponsorIndex = 0;
    }
    NSDictionary *sponsor = [[[AppDelegate sharedAppDelegate] sponsors] objectAtIndex:_sponsorIndex];
    [_sponsorImage setImageWithURL:[NSURL URLWithString:[sponsor objectForKey:@"image"]]];
    _sponsorTitle.text = [sponsor objectForKey:@"title"];
    _sponsorLine.text = [sponsor objectForKey:@"single"];
}

- (void)sponsorTap:(UITapGestureRecognizer *)tap {
    
    
    NSDictionary *sponsor = [[[AppDelegate sharedAppDelegate] sponsors] objectAtIndex:_sponsorIndex];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    SponsorViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"sponsorDialog"];
    vc.sponsor = sponsor;
    [vc willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0];
    [vc didRotateFromInterfaceOrientation:UIInterfaceOrientationPortrait];
    [self.view addSubview:vc.view];
    
    [vc retain];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
}



- (void)dealloc {
    [_sponsorTimer invalidate];
    [_featured release];
    [_mainView release];
    [_btnFeatured release];
    [_btnGenre release];
    [_btnSubject release];
    [_btnArtist release];
    [_btnAll release];
    [_trayView release];
    [_sponsorImage release];
    [_sponsorTitle release];
    [_sponsorLine release];
    [_sponsorView release];
    [super dealloc];
}
- (void)selectArtist:(NSNotification *)note {
    if (_popover)
        [_popover dismissPopoverAnimated:YES];
    _btnFeatured.selected = _btnGenre.selected = _btnAll.selected = _btnSubject.selected = _btnArtist.selected = NO;
    _btnArtist.selected = YES;
    
    NSDictionary *query = [NSDictionary dictionaryWithObject:[note.userInfo objectForKey:@"id"] forKey:@"artistId"];

        [UIView animateWithDuration:.3 animations:^{
            _activeController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [_activeController.view removeFromSuperview];
            [_activeController release];
            [self performSelectorOnMainThread:@selector(performQuery:) withObject:query waitUntilDone:NO];
        }];
}
- (void)selectGenre:(NSNotification *)note {
    if (_popover)
        [_popover dismissPopoverAnimated:YES];
    _btnFeatured.selected = _btnGenre.selected = _btnAll.selected = _btnSubject.selected = _btnArtist.selected = NO;
    _btnGenre.selected = YES;
    
    NSDictionary *query = [NSDictionary dictionaryWithObject:[note.userInfo objectForKey:@"term_id"] forKey:@"genreId"];

    [UIView animateWithDuration:.3 animations:^{
        _activeController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [_activeController.view removeFromSuperview];
        [_activeController release];
        [self performSelectorOnMainThread:@selector(performQuery:) withObject:query waitUntilDone:NO];
    }];
}
- (void)selectCategory:(NSNotification *)note {
    if (_popover)
        [_popover dismissPopoverAnimated:YES];
    _btnFeatured.selected = _btnGenre.selected = _btnAll.selected = _btnSubject.selected = _btnArtist.selected = NO;
    _btnSubject.selected = YES;
    
    NSDictionary *query = [NSDictionary dictionaryWithObject:[note.userInfo objectForKey:@"term_id"] forKey:@"category"];

    [UIView animateWithDuration:.3 animations:^{
        _activeController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [_activeController.view removeFromSuperview];
        [_activeController release];
        [self performSelectorOnMainThread:@selector(performQuery:) withObject:query waitUntilDone:NO];
    }];
}
- (IBAction)showFeatured:(id)sender {
    _btnFeatured.selected = _btnGenre.selected = _btnAll.selected = _btnSubject.selected = _btnArtist.selected = NO;
    _btnFeatured.selected = YES;
    if (_activeController == _featured) {
        return;
    } else {

        [UIView animateWithDuration:.3 animations:^{
            _activeController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [_activeController.view removeFromSuperview];
            [_activeController release];
            _featured = [[[FeaturedGridViewController alloc] initWithFrame:CGRectMake(0, 0, _mainView.frame.size.width, _mainView.frame.size.height)] retain];
            [_mainView addSubview:_featured.view];
            
            _activeController = _featured;
            
        }];
    }
}

- (IBAction)showAll:(id)sender {
    _btnFeatured.selected = _btnGenre.selected = _btnAll.selected = _btnSubject.selected = _btnArtist.selected = NO;
    _btnAll.selected = YES;
    
    NSDictionary *query = [NSDictionary dictionary];
    if (_activeController == _featured) {
        [UIView animateWithDuration:.3 animations:^{
            _featured.view.alpha = 0; 
        } completion:^(BOOL finished) {            
            [self performSelectorOnMainThread:@selector(performQuery:) withObject:query waitUntilDone:NO];
        }];
    } else {
        [UIView animateWithDuration:.3 animations:^{
            _activeController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [_activeController.view removeFromSuperview];
            [_activeController release];
            [self performSelectorOnMainThread:@selector(performQuery:) withObject:query waitUntilDone:NO];
        }];
    }
}
@end
