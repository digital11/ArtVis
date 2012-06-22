//
//  DetailDialogViewController.h
//  Gallery
//
//  Created by Chris Bower on 5/23/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailDialogViewController : UIViewController

@property (retain, nonatomic) NSDictionary *art;

@property (retain, nonatomic) IBOutlet UIView *background;
@property (retain, nonatomic) IBOutlet UIView *dialog;
@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (retain, nonatomic) IBOutlet UIScrollView *scroller;
@property (retain, nonatomic) IBOutlet UILabel *artistLabel;
@property (retain, nonatomic) IBOutlet UILabel *artistText;
@property (retain, nonatomic) IBOutlet UILabel *bioLabel;
@property (retain, nonatomic) IBOutlet UILabel *bioText;
@property (retain, nonatomic) IBOutlet UILabel *pieceLabel;
@property (retain, nonatomic) IBOutlet UILabel *pieceText;
@property (retain, nonatomic) IBOutlet UILabel *sizeLabel;
@property (retain, nonatomic) IBOutlet UIButton *viewSize1;
@property (retain, nonatomic) IBOutlet UIButton *viewSize2;
@property (retain, nonatomic) IBOutlet UILabel *artTitle;

- (void)populate:(NSDictionary *)art;
@end
