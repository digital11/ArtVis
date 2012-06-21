//
//  FullViewController.h
//  Gallery
//
//  Created by Chris Bower on 6/4/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArtView;
@interface FullViewController : UIViewController<UIScrollViewDelegate> {
    CGRect _oldFrame;
    BOOL _isFull;
}
@property (nonatomic, strong) NSDictionary *art;
- (IBAction)tap:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *artistLabel;
@property (retain, nonatomic) IBOutlet UILabel *artistText;
@property (retain, nonatomic) IBOutlet UILabel *bioLabel;
@property (retain, nonatomic) IBOutlet UILabel *bioText;
@property (retain, nonatomic) IBOutlet UILabel *pieceLabel;
@property (retain, nonatomic) IBOutlet UILabel *pieceText;
@property (retain, nonatomic) IBOutlet UILabel *sizeLabel;
@property (retain, nonatomic) IBOutlet UIButton *viewSize1;
@property (retain, nonatomic) IBOutlet UIButton *viewSize2;
@property (retain, nonatomic) IBOutlet UIScrollView *imageScroller;
@property (retain, nonatomic) IBOutlet ArtView *image;
@property (retain, nonatomic) IBOutlet UIScrollView *scroller;
- (void)populate:(NSDictionary *)art;
- (IBAction)back:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *fullscreenBtn;

- (IBAction)related:(id)sender;
@property (retain, nonatomic) IBOutlet ArtView *related1;
@property (retain, nonatomic) IBOutlet ArtView *related2;
@property (retain, nonatomic) IBOutlet ArtView *related3;
@property (retain, nonatomic) IBOutlet ArtView *related4;
@end
