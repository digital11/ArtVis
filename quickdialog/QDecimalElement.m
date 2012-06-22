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

#import "QEntryTableViewCell.h"
#import "QDecimalTableViewCell.h"
#import "QDecimalElement.h"

@implementation QDecimalElement

@synthesize floatValue = _floatValue;
@synthesize fractionDigits = _fractionDigits;


- (QDecimalElement *)initWithTitle:(NSString *)title value:(float)value {
    self = [super initWithTitle:title Value:nil] ;
    if (self) {
        self.textValueAlignment= UITextAlignmentRight;
        self.addToAlignment = YES;
        self.textValueColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
        _floatValue = value;
    }
    
    return self;
}


- (QDecimalElement *)initWithValue:(float)value {
    self = [super init];
    if (self) {
        self.textValueAlignment= UITextAlignmentRight;
        self.addToAlignment = YES;
        self.textValueColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
        _floatValue = value;
    }
    return self;
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {

    QDecimalTableViewCell *cell = (QDecimalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"QuickformDecimalElement"];
    if (cell==nil){
        cell = [[[QDecimalTableViewCell alloc] init] autorelease];
    }
    [cell prepareForElement:self inTableView:tableView];
    return cell;

}

- (void)fetchValueIntoObject:(id)obj {
	if (self.key==nil)
		return;
    [obj setValue:[NSNumber numberWithFloat:_floatValue] forKey:self.key];
}

@end