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
    UIView *_oldGrid;
    NSTimer *_timer;
}
@property (retain, nonatomic) IBOutlet UIView *grid;
@property (retain, nonatomic) IBOutlet ArtView *artView;
- (void)showFullTv:(NSDictionary *)art;
- (void)hideFullTv;
@end
