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

#import "QElement.h"
#import "QSection.h"
#import "QuickDialogStyleProvider.h"
#import "QuickDialogDataSource.h"
#import "QuickDialogTableDelegate.h"
#import "QRootElement.h"
#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface QuickDialogTableView : UITableView {

}

@property(nonatomic, retain) QRootElement *root;
@property(nonatomic, retain, readonly) QuickDialogController *controller;
@property(nonatomic, retain) UITableViewCell *selectedCell;
@property(nonatomic, retain) id<QuickDialogStyleProvider> styleProvider;
@property(nonatomic, retain) UIImage* customSeparatorImage;
@property(nonatomic, retain) UIImage* requiredIconImage;


- (id)initWithController:(QuickDialogController *)controller;

- (UITableViewCell *)cellForElement:(QElement *)element;
- (void)viewWillAppear;

- (BOOL)allRequiredFieldsFilledIn;
- (void)clearErrorImagesFromRequiredFields;

@end