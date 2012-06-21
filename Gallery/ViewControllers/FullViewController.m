//
//  FullViewController.m
//  Gallery
//
//  Created by Chris Bower on 6/4/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import "FullViewController.h"
#import "ArtView.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "AFJSONRequestOperation.h"
#import "DataSelectorViewController.h"
#import "SizesDataSource.h"

@implementation FullViewController
@synthesize fullscreenBtn = _fullscreenBtn;
@synthesize related1 = _related1;
@synthesize related2 = _related2;
@synthesize related3 = _related3;
@synthesize related4 = _related4;
@synthesize artistLabel = _artistLabel;
@synthesize artistText = _artistText;
@synthesize bioLabel = _bioLabel;
@synthesize bioText = _bioText;
@synthesize pieceLabel = _pieceLabel;
@synthesize pieceText = _pieceText;
@synthesize sizeLabel = _sizeLabel;
@synthesize viewSize1 = _viewSize1;
@synthesize viewSize2 = _viewSize2;
@synthesize imageScroller = _imageScroller;
@synthesize image = _image;
@synthesize scroller = _scroller;
@synthesize art = _art;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"size"]) {
        [(DataSelectorViewController *)segue.destinationViewController setDataSource:[[[SizesDataSource alloc] init:[_art objectForKey:@"sizes"]] autorelease]];
        //        UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
        //        _popover = popoverSegue.popoverController;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
    [_art release];
    [_artistLabel release];
    [_artistText release];
    [_bioLabel release];
    [_bioText release];
    [_pieceLabel release];
    [_pieceText release];
    [_sizeLabel release];
    [_viewSize1 release];
    [_viewSize2 release];
    [_image release];
    [_scroller release];
    [_fullscreenBtn release];
    [_related1 release];
    [_related2 release];
    [_related3 release];
    [_related4 release];
    [_imageScroller release];
    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_image addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (void)viewDidUnload
{
    [self setArtistLabel:nil];
    [self setArtistText:nil];
    [self setBioLabel:nil];
    [self setBioText:nil];
    [self setPieceLabel:nil];
    [self setPieceText:nil];
    [self setSizeLabel:nil];
    [self setViewSize1:nil];
    [self setViewSize2:nil];
    [self setImage:nil];
    [self setScroller:nil];
    [self setFullscreenBtn:nil];
    [self setRelated1:nil];
    [self setRelated2:nil];
    [self setRelated3:nil];
    [self setRelated4:nil];
    [self setImageScroller:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
- (void)viewWillAppear:(BOOL)animated {
    _isFull = NO;
    [self populate:_art];
}

- (IBAction)tap:(id)sender {
    if (_isFull) {
        _isFull = NO;
        
        [UIView animateWithDuration:0.4 animations:^{
            _scroller.backgroundColor = [UIColor clearColor];
            _scroller.opaque = NO;
            _imageScroller.frame = _oldFrame;
            _image.frame = CGRectMake(0, 0, _oldFrame.size.width, _oldFrame.size.height);  
            _imageScroller.contentSize = _oldFrame.size;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                _fullscreenBtn.alpha = 0;
            }];
        }];
    } else {
        _oldFrame = _imageScroller.frame;
        _isFull = YES;
        [UIView animateWithDuration:0.1 animations:^{
            _fullscreenBtn.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _scroller.backgroundColor = [UIColor blackColor];
                _scroller.opaque = YES;
                _imageScroller.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                _image.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);  
                _imageScroller.contentSize = _image.frame.size;
            }];

        }];
    }
}

- (void)populate:(NSDictionary *)art {
    //self.art = art;
    [AppDelegate showFullTv:art];
    CGRect frame;
    [_image setImageWithURL:[NSURL URLWithString:[art objectForKey:@"large"]]];
    
    _image.contentMode = UIViewContentModeScaleAspectFit;
    _image.clipsToBounds = YES;
    NSDictionary *artist = [AppDelegate getArtist:[[art objectForKey:@"artistId"] intValue]];
    
    _artistText.text = [artist objectForKey:@"artist"];
    _artistText.numberOfLines = 0;
    frame = _artistText.frame;
    frame.size.height = 0;
    frame.size.width = 223;
    _artistText.frame = frame;
    [_artistText sizeToFit];
    
    
    frame = _bioLabel.frame;
    frame.origin.y = _artistText.frame.size.height + _artistText.frame.origin.y + 15;
    _bioLabel.frame = frame;
    _bioText.text = [artist objectForKey:@"bio"];
    frame = _bioText.frame;
    frame.size.height = 0;
    frame.size.width = 223;
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
    frame.size.width = 223;
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
    frame.size.width = 223;
    frame.origin.y = _sizeLabel.frame.origin.y + _sizeLabel.frame.size.height + 5;
    _viewSize2.frame = frame;
    
    [_scroller setContentSize:CGSizeMake(_scroller.frame.size.width, _viewSize1.frame.origin.y + _viewSize1.frame.size.height + 15)];
    
    
    
    //    http://www.swarmx.com/clients/studio1/index.cfm?api=getARTFEATURE&gridblocks=15
    NSURL *url = [NSURL URLWithString:API(@"art/get_random/?&count=4&exclude=tags,categories")];//API(@"api=getARTFEATURE&gridblocks=15")];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        int i=1;
        ArtView *av = _related1;
        for (NSDictionary *dict in [JSON objectForKey:@"posts"]) {
            switch (i) {                    
                case 2:
                    av = _related2;
                    break;
                case 3:
                    av = _related3;
                    break;
                case 4:
                    av = _related4;
                    break;
            }
            i++;
            av.art = dict;
            av.contentMode = UIViewContentModeScaleAspectFill;
            [av setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"small"]] placeholderImage:nil];
            self.imageScroller.contentSize = av.frame.size;
            self.imageScroller.minimumZoomScale = 1.0;
            self.imageScroller.maximumZoomScale = 6.0;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];

}

- (IBAction)back:(id)sender {
    _image.userInteractionEnabled = NO;
    [(UINavigationController *)[[[AppDelegate sharedAppDelegate] window] rootViewController] popViewControllerAnimated:YES];
}
- (IBAction)related:(UIGestureRecognizer *)sender {
    ArtView *av = (ArtView *)sender.view;
    [self populate:av.art];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.image;
}
@end
