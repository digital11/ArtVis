//
//  UIView+QuickAnimations.m
//  Vyaggio
//
//  Created by Jan-Rixt Van Hoye on 15/12/11.
//  Copyright (c) 2011 BurnTide. All rights reserved.
//

#import "UIView+QuickAnimations.h"
#import <QuartzCore/QuartzCore.h>

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation UIView(QuickAnimations)

- (void)shakeView {
    if ([self.layer.animationKeys count] > 0) return;
    CGFloat t = 2.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    
    self.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        self.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}
- (void)slideInFrom:(CGRect)fromRect to:(CGRect)toRect {
    if ([self.layer.animationKeys count] > 0) return;
    self.hidden = NO;
    self.frame = fromRect;
    [self.layer setAnchorPoint:CGPointMake(.5f, 1.f)];
    self.center = CGPointMake(self.center.x, toRect.origin.y + toRect.size.height);
    CGAffineTransform translateRight  = CGAffineTransformRotate(self.transform, DEGREES_TO_RADIANS(-10.f));
    CGAffineTransform translateLeft = CGAffineTransformRotate(self.transform, DEGREES_TO_RADIANS(10.f));

    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.frame = toRect;
        self.transform = translateLeft;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
                [UIView setAnimationRepeatCount:2.0];
                self.transform = translateRight;
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        self.transform = CGAffineTransformRotate(self.transform, DEGREES_TO_RADIANS(10.f));
                    } completion:NULL];
                }
            }];
        }
    }];
}
- (void)slideOutFrom:(CGRect)fromRect to:(CGRect)toRect {
    if ([self.layer.animationKeys count] > 0) return;
    self.frame = fromRect;
    [self.layer setAnchorPoint:CGPointMake(.5f, 1.f)];
    self.center = CGPointMake(self.center.x, fromRect.origin.y + fromRect.size.height);
    CGAffineTransform translateLeft = CGAffineTransformRotate(self.transform, DEGREES_TO_RADIANS(10.f));
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.frame = toRect;
        self.transform = translateLeft;
    } completion:^(BOOL finished) {
        if (finished) {
            self.transform = CGAffineTransformRotate(self.transform, DEGREES_TO_RADIANS(-10.f));
            self.hidden = YES;
        }
    }];
}


@end
