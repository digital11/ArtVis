//
//  QListPickerTableViewCell.m
//  ZipMark
//
//  Created by Paul Newman on 9/26/11.
//  Copyright (c) 2011 Newman Zone. All rights reserved.
//

#import "QListPickerTableViewCell.h"
#import "QListPickerInlineElement.h"

@implementation QListPickerTableViewCell

@synthesize pickerView;
@synthesize valueLabel;
@synthesize list;

- (QListPickerTableViewCell *)init {
    self = [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QuickformListPickerInlineElement"];
    if (self!=nil){
        [self createSubviews];
		self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

-(void)dealloc {
    self.pickerView = nil;
    self.valueLabel = nil;
    self.list = nil;
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
    self.valueLabel.frame = CGRectMake(10, 10, self.contentView.frame.size.width, self.contentView.frame.size.height-20);
    self.valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.valueLabel.text =  @"";
    [self.contentView addSubview:self.valueLabel];
    
}


- (void)prepareForElement:(QEntryElement *)element inTableView:(QuickDialogTableView *)tableView {
    [super prepareForElement:element inTableView:tableView];
    
    QListPickerInlineElement *entry = (QListPickerInlineElement *)element;
    
    if (!entry.centerLabel){
		self.textLabel.text = element.title;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.valueLabel.textAlignment = entry.textValueAlignment;
        self.valueLabel.text = entry.selectedItem;
		
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.textLabel.text = nil;
        self.valueLabel.textAlignment = UITextAlignmentCenter;
		self.valueLabel.text = entry.selectedItem;
    }
	
	self.textField.text = entry.selectedItem;
    self.textField.placeholder = entry.placeholder;    
    self.textField.inputAccessoryView.hidden = entry.hiddenToolbar;
    
    [self refresh];
}


#pragma mark - UIPickerViewDelegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView 
{ 
    // How many columns will be used in the UIPickerView
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component 
{ 
    // How many rows the UIPickerView will have
	return [list count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{ 
    // What is the label of each row
	return [list objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{ 
    QListPickerInlineElement *el = (QListPickerInlineElement *)self.entryElement;
    el.textValue = [list objectAtIndex:row];
    el.selectedItem = el.textValue;
    if (el.textValue && ![el.textValue isEqualToString:@""]) {
        el.isInError = NO;
    }
    el.selectedIndex = row;
    [self prepareForElement:self.entryElement inTableView:self.quickformTableView];
}

#pragma mark Overridded methods

- (BOOL)becomeFirstResponder {
    QListPickerInlineElement *entry = (QListPickerInlineElement *)self.entryElement;
    if (!self.pickerView) { // Create the picker only when it is needed
        self.pickerView = [[[UIPickerView alloc] init] autorelease];
        [self.pickerView sizeToFit];
        self.pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self.pickerView setShowsSelectionIndicator:YES];
        [self.pickerView setDataSource:self];
        [self.pickerView setDelegate:self];
        [self.pickerView selectRow:entry.selectedIndex inComponent:0 animated:YES];
        self.textField.inputView = self.pickerView;
    }
    else {
        [self.pickerView selectRow:entry.selectedIndex inComponent:0 animated:YES];
    }
    return [super becomeFirstResponder];
}

- (void)showErrorButton {
    [super showErrorButton];
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)hideErrorButton {
    [super hideErrorButton];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}

- (void)recalculateEntryFieldPosition {
    self.entryElement.parentSection.entryPosition = CGRectZero;
    self.valueLabel.frame = [self calculateFrameForEntryElement];
    self.errorImageView.frame = [self calculateErrorImageViewFrame];
    NSLog(@"QListPicker -> xpos: %f", self.valueLabel.frame.origin.x);
}

- (void)_checkIfInError {
    //
}

@end
