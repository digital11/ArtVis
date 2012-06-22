//
//  UIView+QuickAnimations.h
//  Vyaggio
//
//  Created by Jan-Rixt Van Hoye on 15/12/11.
//  Copyright (c) 2011 BurnTide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(QuickAnimations)

- (void)shakeView;
- (void)slideInFrom:(CGRect)fromRect to:(CGRect)toRect;
- (void)slideOutFrom:(CGRect)fromRect to:(CGRect)toRect;

@end
