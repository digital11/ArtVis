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

#import <objc/message.h>

@implementation QElement


@synthesize parentSection;
@synthesize key;
@synthesize onSelected;
@synthesize controllerAction;
@synthesize cellHeight;
@synthesize cellTopBottomMargin;
@synthesize useCellHeight = mUseCellHeight;
@synthesize required;

- (id) init {
    self = [super init];
    if (self) {
        mUseCellHeight = NO;
        cellHeight = 44.f;
        self.cellTopBottomMargin = 11.f;
        self.required = NO;
    }
    return self;
}
- (id)initWithKey:(NSString *)inKey {
    self = [super init];
    if (self) {
        self.key = inKey;
        mUseCellHeight = NO;
        cellHeight = 44.f;
        self.cellTopBottomMargin = 11.f;
        self.required = NO;
    }
    return self;

}
- (void)dealloc {
    self.parentSection = nil;
    self.key = nil;
    self.onSelected = nil;
    self.controllerAction = nil;
    [super dealloc];
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuickformElementCell"];
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QuickformElementCell"] autorelease]; 
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showsReorderControl = YES;
    cell.accessoryView = nil;
    return cell;
}

- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] becomeFirstResponder];
    if (self.onSelected!= nil)
          self.onSelected();

    if (self.controllerAction!=NULL){
        SEL selector = NSSelectorFromString(self.controllerAction);
        if ([tableView.controller respondsToSelector:selector]) {
            objc_msgSend(tableView.controller ,selector, self);
        }
    }
}

- (CGFloat)getRowHeightForTableView:(QuickDialogTableView *)tableView {
    return cellHeight==0.f?44.f:cellHeight;
}

- (void)fetchValueIntoObject:(id)obj {
}
- (void)setCellHeight:(float)inCellHeight {
    cellHeight = inCellHeight;
    mUseCellHeight = YES;
}

@end