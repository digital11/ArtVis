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

#import "QuickDialogTableView.h"
#import "QEntryElement.h"

@interface QDateTimeInlineElement : QEntryElement {

@private
    UIDatePickerMode _mode;
    BOOL _centerLabel;
}

@property(nonatomic, retain) NSDate *dateValue;
@property(nonatomic, retain) NSDate *minimumDateValue;
@property(nonatomic, retain) NSDate *maximumDateValue;
@property(assign) UIDatePickerMode mode;
@property(nonatomic) BOOL centerLabel;


- (id)initWithDate:(NSDate *)date;
- (id)initWithTitle:(NSString *)string date:(NSDate *)date;


@end