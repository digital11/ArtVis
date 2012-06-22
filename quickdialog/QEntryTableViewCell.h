//                                
// Copyright 2011 ESCOZ Inc  - http://escoz.com
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QEntryElement;
@class QuickDialogTableView;


@interface QEntryTableViewCell : UITableViewCell<UITextFieldDelegate> {
    int myTextFieldSemaphore;
}

@property (nonatomic, retain) QEntryElement *entryElement;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIToolbar *actionBar;
@property (nonatomic, retain) QuickDialogTableView *quickformTableView;
@property (nonatomic, retain) UIImageView *errorImageView;

- (void)prepareForElement:(QEntryElement *)element inTableView:(QuickDialogTableView *)tableView;

- (void)createSubviews;

- (QEntryElement *)findNextElementToFocusOn;
- (QEntryElement *)findPreviousElementToFocusOn;


- (void)refresh;
- (void)recalculateEntryFieldPosition;
- (CGRect)calculateFrameForEntryElement;
- (CGRect)calculateErrorImageViewFrame;


- (void)showErrorButton;
- (void)hideErrorButton;

- (void)_checkIfInError;


@end