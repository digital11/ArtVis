//
//  QuickDialogControllerSubClass.h
//  dib
//
//  Created by Jan-Rixt Van Hoye on 16/10/11.
//  Copyright (c) 2011 Thuis. All rights reserved.
//

#import "QuickDialogController.h"

@interface QuickDialogController()

- (void)keyboardWillShow:(NSNotification *)nsNotification;
- (void)keyboardDidShow:(NSNotification *)nsNotification;
- (void)keyboardWillHide:(NSNotification *)nsNotification;
- (void)keyboardDidHide:(NSNotification *)nsNotification;

@property (nonatomic, assign) CGRect tableRect;
@property (nonatomic, assign) CGSize contenSize;
@property (nonatomic, assign) BOOL keyboardVisible;
@property (nonatomic, assign) float tableOffset;


@end