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

#import "QDecimalTableViewCell.h"
#import "QEntryElement.h"
#import "QDecimalElement.h"
#import "NumberKeypadDecimalPoint.h"

@interface QDecimalTableViewCell ()

- (BOOL)systemversionIsHigherThen40;

@property (nonatomic, retain) NSNumberFormatter *numberFormatter;
@property (nonatomic, retain) NumberKeypadDecimalPoint *numberKeyPad;

@end

@implementation QDecimalTableViewCell

@synthesize numberFormatter;
@synthesize numberKeyPad;

- (QDecimalTableViewCell *)init {
    self = [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QuickformDecimalElement"];
    if (self!=nil){
        [self createSubviews];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
        [self.numberFormatter setUsesSignificantDigits:YES];
        [self.numberFormatter setLocale:[NSLocale currentLocale]];
    };
    return self;
}
- (void)dealloc {
    self.numberFormatter = nil;
}

- (void)createSubviews {
    [super createSubviews];
    self.textField.keyboardType = [self systemversionIsHigherThen40]?UIKeyboardTypeDecimalPad:UIKeyboardTypeNumberPad;
    [self setNeedsLayout];
}

- (QDecimalElement *)decimalElement {
    return ((QDecimalElement *)self.entryElement);
}

- (void)prepareForElement:(QEntryElement *)element inTableView:(QuickDialogTableView *)view {
    [super prepareForElement:element inTableView:view];
    self.entryElement = element;
    self.textField.textAlignment = element.textValueAlignment;
    self.textField.keyboardType = [self systemversionIsHigherThen40]?UIKeyboardTypeDecimalPad:UIKeyboardTypeNumberPad;
    self.textField.textColor = element.textValueColor;
}

- (BOOL)updateElementFromTextField:(NSString *)value {
    NSArray *_array = [value componentsSeparatedByString:[self.numberFormatter decimalSeparator]];
    if ([_array count] > 1) {
        NSString *fractionDigitsString = [_array objectAtIndex:1];
        QDecimalElement *el = (QDecimalElement *)self.entryElement;
        if (fractionDigitsString.length > el.fractionDigits) {
            return NO;
        }
    }
    [self decimalElement].floatValue= [value floatValue];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacement {
    NSString *newValue = [self.textField.text stringByReplacingCharactersInRange:range withString:replacement];
    if([self updateElementFromTextField:newValue])
        textField.text = newValue;
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {	
    self.quickformTableView.selectedCell = self;
    if([self systemversionIsHigherThen40]) return;
	self.numberKeyPad = [NumberKeypadDecimalPoint keypadForTextField:textField];	
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
	if([self systemversionIsHigherThen40]) return;
    [self.numberKeyPad removeButtonFromKeyboard];
    self.numberKeyPad = nil;
}
- (BOOL)systemversionIsHigherThen40 {
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion > 4.0f)
        return YES;
    return NO;
}


@end