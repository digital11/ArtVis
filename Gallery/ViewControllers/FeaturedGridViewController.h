//
//  FeaturedGridViewController.h
//  Gallery
//
//  Created by Chris Bower on 6/18/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedGridViewController : UIViewController {
    
    UIView *_oldGrid;
    NSTimer *_timer;
    BOOL _inited;
}
@property (retain, nonatomic) IBOutlet UIView *grid;
- (id)initWithFrame:(CGRect)frame;
@end
