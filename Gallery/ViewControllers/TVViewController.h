//
//  TVViewController.h
//  Gallery
//
//  Created by Chris Bower on 5/25/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArtView;
@interface TVViewController : UIViewController {
    NSMutableArray *_art;
    int _artIndex;
    UIView *_oldGrid;
    NSTimer *_timer;
}
@property BOOL isPortrait;
@property BOOL noGrid;
@property (retain, nonatomic) IBOutlet UIView *grid;
@property (retain, nonatomic) IBOutlet ArtView *artView;
- (void)showFullTv:(NSDictionary *)art;
- (void)hideFullTv;
@end
