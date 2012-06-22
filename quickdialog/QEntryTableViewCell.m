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
#import "NSString+PhoneNumberFormatting.h"
#import "UIView+QuickAnimations.h"

@interface QEntryTableViewCell ()

- (void)previousNextDelegate:(UISegmentedControl *)control;
- (QEntryElement *)findNextElementToFocusOn;

@property (nonatomic, assign) CGRect errorImageRect;

@end

@implementation QEntryTableViewCell

@synthesize entryElement;
@synthesize actionBar;
@synthesize textField;
@synthesize quickformTableView;
@synthesize errorImageView;
@synthesize errorImageRect;

-(void)createActionBar {
    if (self.actionBar == nil) {
        self.actionBar = [[[UIToolbar alloc] init] autorelease];
        self.actionBar.translucent = YES;
        [self.actionBar sizeToFit];
        self.actionBar.barStyle = UIBarStyleBlackTranslucent;

        UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(textFieldMustReturn:)] autorelease];

        UISegmentedControl *prevNext = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]] autorelease];
        prevNext.momentary = YES;
        prevNext.segmentedControlStyle = UISegmentedControlStyleBar;
        prevNext.tintColor = [UIColor darkGrayColor];
        [prevNext addTarget:self action:@selector(previousNextDelegate:) forControlEvents:UIControlEventValueChanged];
        UIBarButtonItem *prevNextWrapper = [[[UIBarButtonItem alloc] initWithCustomView:prevNext] autorelease];
        UIBarButtonItem *flexible = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        [self.actionBar setItems:[NSArray arrayWithObjects:prevNextWrapper, flexible, doneButton, nil]];
	}
	self.textField.inputAccessoryView = self.actionBar;
}

- (void)createSubviews {
    self.textField = [[[UITextField alloc] init] autorelease];
    [self.textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:self.textField];
    //
    self.errorImageView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    self.errorImageView.hidden = YES;
    self.errorImageView.contentMode= UIViewContentModeCenter;
    [self.contentView addSubview:self.errorImageView];                    
    
    [self setNeedsLayout];
}

- (QEntryTableViewCell *)init {
    self = [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QuickformEntryElement"];
    if (self!=nil){
        myTextFieldSemaphore = 0;
        [self createSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void) dealloc {
    self.actionBar = nil;
    self.textField = nil;
    self.errorImageView = nil;
    [super dealloc];
}

- (CGRect)calculateFrameForEntryElement {
    CGFloat separator = 0.f;
    float textFieldTopBottomMargin = entryElement.cellTopBottomMargin;
    if (self.entryElement.title == NULL) {
        if (entryElement.useCellHeight)
            return CGRectIntegral(CGRectMake(10,textFieldTopBottomMargin,self.contentView.frame.size.width-30, entryElement.cellHeight - 2*textFieldTopBottomMargin));    
        return CGRectMake(10,textFieldTopBottomMargin,self.contentView.frame.size.width-30, self.contentView.frame.size.height - 2*textFieldTopBottomMargin);
    }
    CGFloat totalWidth = self.contentView.frame.size.width;
    CGFloat titleWidth = 0;
    
    if (!entryElement.alignValueField) {
        CGFloat fontSize = self.textLabel.font.pointSize == 0? 18 : self.textLabel.font.pointSize;
        CGSize size = [entryElement.title sizeWithFont:[self.textLabel.font fontWithSize:fontSize] forWidth:CGFLOAT_MAX lineBreakMode:UILineBreakModeWordWrap] ;
        if (size.width>titleWidth)
            titleWidth = size.width;
        separator = titleWidth > 0 ? 20 : 0;
        NSLog(@"title width: %f",titleWidth);
        if (entryElement.useCellHeight) 
            return CGRectIntegral(CGRectMake(titleWidth+separator,textFieldTopBottomMargin,totalWidth-titleWidth-(separator*2),entryElement.cellHeight - 2*textFieldTopBottomMargin));
        return CGRectMake(titleWidth+separator,textFieldTopBottomMargin,totalWidth-titleWidth-(separator*2),self.contentView.frame.size.height - 2*textFieldTopBottomMargin);
    }
    else {
        if (CGRectEqualToRect(CGRectZero, self.entryElement.parentSection.entryPosition)) {
            
            for (QElement *el in self.entryElement.parentSection.elements){
                if ([el isKindOfClass:[QEntryElement class]] && ([(QEntryElement *)el addToAlignment] || self.entryElement == el)){
                    CGFloat fontSize = self.textLabel.font.pointSize == 0? 18 : self.textLabel.font.pointSize;
                    CGSize size = [((QEntryElement *)el).title sizeWithFont:[self.textLabel.font fontWithSize:fontSize] forWidth:CGFLOAT_MAX lineBreakMode:UILineBreakModeWordWrap] ;
                    if (size.width>titleWidth)
                        titleWidth = size.width;
                }
            }
            
            separator = titleWidth > 0 ? 20 : 0;
            if (entryElement.useCellHeight)
                self.entryElement.parentSection.entryPosition = CGRectIntegral(CGRectMake(titleWidth+separator,textFieldTopBottomMargin,totalWidth-titleWidth-(separator*2),entryElement.cellHeight - 2*textFieldTopBottomMargin));
            else
                self.entryElement.parentSection.entryPosition = CGRectMake(titleWidth+separator,textFieldTopBottomMargin,totalWidth-titleWidth-(separator*2),self.contentView.frame.size.height - 2*textFieldTopBottomMargin);
        }
        NSLog(@"title width: %f",titleWidth);
        return self.entryElement.parentSection.entryPosition;
    }
}

- (CGRect)calculateErrorImageViewFrame {
    errorImageRect = self.frame;
    errorImageRect.origin.x = (errorImageRect.origin.x + errorImageRect.size.width) -  34.f;
    errorImageRect.origin.y = ceilf((entryElement.cellHeight - 29.f)*.5f);
    errorImageRect.size.width = 29.f;
    errorImageRect.size.height = 29.f;
    return errorImageRect;
}

- (void)prepareForElement:(QEntryElement *)element inTableView:(QuickDialogTableView *)tableView{
    self.textLabel.text = element.title;
    
    self.quickformTableView = tableView;
    self.entryElement = element;
    [self recalculateEntryFieldPosition];
    if (entryElement.useCellHeight)
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.text = self.entryElement.textValue;
    self.textField.placeholder = self.entryElement.placeholder;
    self.textField.secureTextEntry = self.entryElement.isPassword;
    self.textField.keyboardType = self.entryElement.isNumeric ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault; 
    self.textField.textAlignment = element.textValueAlignment;
    self.textField.textColor = element.textValueColor;
    self.textField.backgroundColor = [UIColor clearColor];
    if (self.entryElement.hiddenToolbar){
        self.textField.inputAccessoryView = nil;
    } else {
        [self createActionBar];
    }
    // Custom separator
    for (QSection *section in tableView.root.sections) {
        NSUInteger count = [section.elements count];
        if (count > 0) {
            if ([section.elements objectAtIndex:count-1] != element) {
                // show the separator if the cell is not the latest cell of the section
                if (tableView.customSeparatorImage != nil) {
                    UIImageView *separatorImageView = [[[UIImageView alloc] initWithImage:tableView.customSeparatorImage] autorelease];
                    separatorImageView.frame = CGRectIntegral(CGRectMake((self.frame.size.width - tableView.customSeparatorImage.size.width)*.5f, self.frame.size.height-tableView.customSeparatorImage.size.height, tableView.customSeparatorImage.size.width, tableView.customSeparatorImage.size.height));;
                    separatorImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
                    [self addSubview:separatorImageView];
                } 
            }
        }
    }
    // Error button
    if (tableView.requiredIconImage != nil)
        [self.errorImageView setImage:tableView.requiredIconImage];
}

- (void)refresh {
    [self recalculateEntryFieldPosition];
    if (self.entryElement.isInError) {
        self.errorImageView.hidden = NO;
        [self.errorImageView setFrame:errorImageRect];
    }
    else {
        self.errorImageView.hidden = YES;
        CGRect toRect = CGRectMake(self.frame.size.width,self.errorImageView.frame.origin.y, self.errorImageView.frame.size.width, self.errorImageView.frame.size.height);
        [self.errorImageView setFrame:toRect];
    }
}

- (void)recalculateEntryFieldPosition {
    self.entryElement.parentSection.entryPosition = CGRectZero;
    self.textField.frame = [self calculateFrameForEntryElement];
    NSLog(@"QEntry -> xpos: %f", self.textField.frame.origin.x);
    self.errorImageView.frame = [self calculateErrorImageViewFrame];
}

- (void)prepareForReuse {
    self.quickformTableView = nil;
    self.entryElement = nil;
}

- (void)textFieldEditingChanged:(UITextField *)textFieldEditingChanged {
    
    if (self.entryElement.isPhoneNumber) {
        
        if(myTextFieldSemaphore) return;
        
        myTextFieldSemaphore = 1;
        
        self.textField.text = [[self.textField text] formattedPhoneNumberForLocale:xPhoneNumberLocale_US];
        
        myTextFieldSemaphore = 0;
    }
    
    self.entryElement.textValue = self.textField.text;    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIReturnKeyType returnType = ([self findNextElementToFocusOn]!=nil) ? UIReturnKeyNext : UIReturnKeyDone;
    self.textField.returnKeyType = returnType;
    self.quickformTableView.selectedCell = self;
    self.errorImageView.hidden = YES;
}

- (BOOL)textField:(UITextField *)inTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.entryElement.isUppercase) {
        NSRange lowercaseCharRange;
        lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
        
        if (lowercaseCharRange.location != NSNotFound) {
            
            inTextField.text = [inTextField.text stringByReplacingCharactersInRange:range withString:[string uppercaseString]];
            self.entryElement.textValue = self.textField.text;
            return NO;
        }
    }
    return YES;
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected==YES){
        [self.textField becomeFirstResponder];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.entryElement.textValue = self.textField.text;
    [self _checkIfInError];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];

    QEntryElement *element = [self findNextElementToFocusOn];
    if (element!=nil){
        UITableViewCell *cell = [self.quickformTableView cellForElement:element];
        if (cell!=nil){
            [cell becomeFirstResponder];
        }
    }
    return YES;
}

- (void) previousNextDelegate:(UISegmentedControl *)control {
	QEntryElement *element; 
	if (control.selectedSegmentIndex == 1){
		element = [self findNextElementToFocusOn];
		
	} else {
		element = [self findPreviousElementToFocusOn];
	}
	if (element!=nil){
		UITableViewCell *cell = [self.quickformTableView cellForElement:element];
		if (cell!=nil){
			[cell becomeFirstResponder];
		}
	}
}


- (BOOL)textFieldMustReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return NO;
}

- (BOOL)becomeFirstResponder {
    [self.textField becomeFirstResponder];
	return YES;
}

- (BOOL)resignFirstResponder {
    [self.textField resignFirstResponder];
	return YES;
}

- (QEntryElement *)findPreviousElementToFocusOn {
    QEntryElement *previousElement = nil;
    for (QElement * e in self.entryElement.parentSection.elements){
        if (e == self.entryElement) {
			return previousElement;
        }
        else if ([e isKindOfClass:[QEntryElement class]]){
            previousElement = (QEntryElement *)e;
        }
    }
    return nil;
}

- (QEntryElement *)findNextElementToFocusOn {
    BOOL foundSelf = NO;
    for (QElement * e in self.entryElement.parentSection.elements){
        if (e == self.entryElement) {
           foundSelf = YES;
        }
        else if (foundSelf && [e isKindOfClass:[QEntryElement class]]){
            return (QEntryElement *) e;
        }
    }
    return nil;
}

- (void)showErrorMessage:(id)sender {
    // Nothing yet
}

- (void)showErrorButton {
    CGRect fromRect = CGRectMake(self.frame.size.width,self.errorImageView.frame.origin.y, self.errorImageView.frame.size.width, self.errorImageView.frame.size.height);
    CGRect toRect = errorImageRect;
    [self.errorImageView slideInFrom:fromRect to:toRect];
}

- (void)hideErrorButton {
    CGRect fromRect = errorImageRect;
    CGRect toRect = CGRectMake(self.frame.size.width,self.errorImageView.frame.origin.y, self.errorImageView.frame.size.width, self.errorImageView.frame.size.height);
    [self.errorImageView slideOutFrom:fromRect to:toRect];
    
}

- (void)_checkIfInError {
    if (self.entryElement.textValue && ![self.entryElement.textValue isEqualToString:@""]) {
        self.entryElement.isInError = NO;
    }
}

@end