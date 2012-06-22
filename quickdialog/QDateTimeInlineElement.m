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

#import "QDateTimeInlineElement.h"
#import "QDateEntryTableViewCell.h"

@implementation QDateTimeInlineElement

@synthesize dateValue;
@synthesize minimumDateValue;
@synthesize maximumDateValue;
@synthesize mode = _mode;
@synthesize centerLabel = _centerLabel;

- (id)init {
    self = [super init];
    return self;
}

- (id)initWithKey:(NSString *)key {
    self = [super initWithKey:key];
    return self;
}

- (id)initWithTitle:(NSString *)string date:(NSDate *)date {
    self = [super initWithTitle:string Value:[date description]];
    if (self!=nil){
        self.dateValue = date;
        _mode = UIDatePickerModeDateAndTime;
        self.centerLabel = NO;
        self.textValueAlignment = UITextAlignmentRight;
        self.textValue = @"";
    }
    return self;
}

- (id)initWithDate:(NSDate *)date {
    return [self initWithTitle:nil date:date];

}
- (void)dealloc {
    self.dateValue = nil;
    self.minimumDateValue = nil;
    self.maximumDateValue = nil;
    [super dealloc];
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {

    QDateEntryTableViewCell *cell = (QDateEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"QuickformDateTimeInlineElement"];
    if (cell==nil){
        cell = [[[QDateEntryTableViewCell alloc] init] autorelease];
    }
    [cell prepareForElement:self inTableView:tableView];
    return cell;

}

- (void)fetchValueIntoObject:(id)obj {
	if (self.key==nil)
		return;
    [obj setValue:self.dateValue forKey:self.key];
}


@end