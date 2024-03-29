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
#import "QSection.h"

@class QuickDialogTableView;
@class QuickDialogController;

@interface QElement : NSObject {
    
    BOOL mUseCellHeight;

}

@property(nonatomic, copy) void (^onSelected)(void);
@property(nonatomic, retain) NSString *controllerAction;
@property(nonatomic, retain) QSection *parentSection;
@property(nonatomic, retain) NSString *key;
@property(nonatomic, assign) float cellHeight;
@property(nonatomic, readonly) BOOL useCellHeight;
@property(nonatomic, assign) float cellTopBottomMargin;
@property(nonatomic, assign, getter=isRequired) BOOL required;


- (id)initWithKey:(NSString *)inKey;

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller;

- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)indexPath;

- (CGFloat)getRowHeightForTableView:(QuickDialogTableView *)tableView;

- (void)fetchValueIntoObject:(id)obj;

@end