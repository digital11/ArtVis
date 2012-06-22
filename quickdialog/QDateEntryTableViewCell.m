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
#import "QDateEntryTableViewCell.h"
#import "QDateTimeInlineElement.h"

@interface QDateEntryTableViewCell ()

- (void)_setDateTimeStyle:(UIDatePickerMode)mode;

@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@end

@implementation QDateEntryTableViewCell

@synthesize pickerView;
@synthesize valueLabel;
@synthesize dateFormatter;


- (QDateEntryTableViewCell *)init {
    self = [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QuickformDateTimeInlineElement"];
    if (self!=nil){
        [self createSubviews];
		self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    }
    return self;
}
- (void)dealloc {
    self.pickerView = nil;
    self.valueLabel = nil;
    self.dateFormatter = nil;
    [super dealloc];
}

- (void)createSubviews {
    [super createSubviews];
    self.textField.hidden = YES;
    
    self.valueLabel = [[[UILabel alloc] init] autorelease];
    self.valueLabel.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
    self.valueLabel.highlightedTextColor = [UIColor whiteColor];
    self.valueLabel.font = [UIFont systemFontOfSize:17];
	self.valueLabel.backgroundColor = [UIColor clearColor];
    self.valueLabel.frame = CGRectMake(10, 10, self.contentView.frame.size.width-20, self.contentView.frame.size.height-20);
    self.valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.valueLabel.text =  @"";
    [self.contentView addSubview:self.valueLabel];
}

- (void) dateChanged:(id)sender{
    QDateTimeInlineElement *dateElement = (QDateTimeInlineElement *) self.entryElement;
    dateElement.dateValue = self.pickerView.date;
    [self prepareForElement:self.entryElement inTableView:self.quickformTableView];
}

- (void)prepareForElement:(QEntryElement *)element inTableView:(QuickDialogTableView *)tableView {
    
    [super prepareForElement:element inTableView:tableView];
    
    QDateTimeInlineElement *dateElement = (QDateTimeInlineElement *) element;
    
    [self _setDateTimeStyle:dateElement.mode];
	
    if (!dateElement.centerLabel){
		self.textLabel.text = element.title;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.valueLabel.textAlignment = dateElement.textValueAlignment;
        if (dateElement.dateValue != nil)
            self.valueLabel.text = [dateFormatter stringFromDate:dateElement.dateValue];
        else
            self.valueLabel.text = @"";
		
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.textLabel.text = nil;
        self.valueLabel.textAlignment = UITextAlignmentCenter;
		self.valueLabel.text = [dateFormatter stringFromDate:dateElement.dateValue];
    }
    
    self.textField.placeholder = dateElement.placeholder;
    self.textField.text = dateElement.textValue;
    self.textField.inputAccessoryView.hidden = dateElement.hiddenToolbar;
    
    [self _setDateTimeStyle:dateElement.mode];
    dateElement.textValue = [dateFormatter stringFromDate:dateElement.dateValue];
    if (dateElement.textValue && ![dateElement.textValue isEqualToString:@""]) {
        dateElement.isInError = NO;
    }
}

#pragma mark - Private methods

- (void)_setDateTimeStyle:(UIDatePickerMode)mode {
    switch (mode) {
        case UIDatePickerModeDate:
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            break;
        case UIDatePickerModeTime:
            [dateFormatter setDateStyle:NSDateFormatterNoStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            break;
    }
}

#pragma mark Overridded methods

- (BOOL)becomeFirstResponder {
    QDateTimeInlineElement *dateElement = (QDateTimeInlineElement *)self.entryElement;
    if (!self.pickerView) { // Create the picker only when it is needed
        self.pickerView = [[[UIDatePicker alloc] init] autorelease];
        [self.pickerView sizeToFit];
        self.pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self.pickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        self.pickerView.datePickerMode = dateElement.mode;
        self.pickerView.minimumDate = dateElement.minimumDateValue;
        self.pickerView.maximumDate = dateElement.maximumDateValue;
        self.textField.inputView = self.pickerView;
    }
    else {
        self.pickerView.date = dateElement.dateValue==nil?[NSDate date]:dateElement.dateValue;
    }
    return [super becomeFirstResponder];
}

- (void)recalculateEntryFieldPosition {
    self.entryElement.parentSection.entryPosition = CGRectZero;
    self.valueLabel.frame = [self calculateFrameForEntryElement];
    self.errorImageView.frame = [self calculateErrorImageViewFrame];
    NSLog(@"QDatePicker -> xpos: %f", self.valueLabel.frame.origin.x);
}

@end