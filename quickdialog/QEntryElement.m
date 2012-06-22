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
#import "QEntryElement.h"

#define DEFAULT_TEXTVALUE_COLOR [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0]

@implementation QEntryElement

@synthesize textValue;
@synthesize placeholder;
@synthesize errorMessage;
@synthesize hiddenToolbar;
@synthesize isPassword;
@synthesize isNumeric;
@synthesize isPhoneNumber;
@synthesize isUppercase;
@synthesize alignValueField;
@synthesize addToAlignment;
@synthesize textValueAlignment;
@synthesize textValueColor;
@synthesize isInError;

- (id)init {
    self = [super init];
    if (self) {
        self.textValue = @"";
        self.placeholder = @"";
        self.alignValueField = YES;
        self.addToAlignment = YES;
        self.textValueAlignment = UITextAlignmentRight;
        self.textValueColor = DEFAULT_TEXTVALUE_COLOR;
        self.isInError = NO;
    }
    return self;
}
- (id)initWithKey:(NSString *)inKey {
    self = [super initWithKey:inKey];
    if (self) {
        self.textValue = @"";
        self.placeholder = @"";
        self.isUppercase = NO;
        self.alignValueField = YES;
        self.addToAlignment = YES;
        self.textValueAlignment = UITextAlignmentRight;
        self.textValueColor = DEFAULT_TEXTVALUE_COLOR;
        self.isInError = NO;
    }
    return self;
}
- (id)initWithTitle:(NSString *)inTitle Value:(NSString *)inValue {
    self = [super initWithTitle:inTitle Value:inValue];
    if (self) {
        self.textValueColor = DEFAULT_TEXTVALUE_COLOR;
    }
    return self;
}
- (id)initWithTitle:(NSString *)title Value:(NSString *)value Placeholder:(NSString *)inPlaceholder {
    self = [self initWithTitle:title Value:nil];
    self.textValue = value;
    self.placeholder = placeholder;
    self.isUppercase = NO;
    self.alignValueField = YES;
    self.addToAlignment = YES;
    self.textValueAlignment = UITextAlignmentRight;
    self.textValueColor = DEFAULT_TEXTVALUE_COLOR;
    return self;
}
- (void)dealloc {
    self.textValue = nil;
    self.placeholder = nil;
    self.errorMessage = nil;
    self.textValueColor = nil;
    [super dealloc];
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    
    QEntryTableViewCell *cell = (QEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"QuickformEntryElement"];
    if (cell==nil){
        cell = [[[QEntryTableViewCell alloc] init] autorelease];
    }
    [cell prepareForElement:self inTableView:tableView];
    return cell;
    
}

- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)indexPath {
    [super selected:tableView controller:controller indexPath:indexPath];
}

- (void)fetchValueIntoObject:(id)obj {
	if (self.key==nil)
		return;
	
	[obj setValue:self.textValue forKey:self.key];
}


@end