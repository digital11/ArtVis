//
//  QListPickerInlineElement.m
//  ZipMark
//
//  Created by Paul Newman on 9/26/11.
//  Copyright (c) 2011 Newman Zone. All rights reserved.
//

#import "QListPickerInlineElement.h"
#import "QListPickerTableViewCell.h"

@interface QListPickerInlineElement ()

@property (nonatomic,retain) NSArray *dataProvider;

@end

@implementation QListPickerInlineElement

@synthesize dataProvider;
@synthesize centerLabel;
@synthesize selectedItem;
@synthesize selectedIndex;

- (QListPickerInlineElement *)init {
    self = [super init];
    return self;
}

- (QListPickerInlineElement *)initWithTitle:(NSString *)title list:(NSArray *)inList {
    self = [super initWithTitle:title Value:[inList objectAtIndex:0]];
    
    if (self!=nil){
        self.dataProvider = inList;
        self.selectedItem = [inList objectAtIndex:0];
        self.textValueAlignment = UITextAlignmentRight;
    }
    return self;
}
- (QListPickerInlineElement *)initWithTitle:(NSString *)title list:(NSArray *)inList selectedIndex:(NSInteger)index {
    self = [super initWithTitle:title Value:[inList objectAtIndex:index]];
    
    if (self!=nil){
        self.dataProvider = inList;
        self.selectedItem = [inList objectAtIndex:index];
        self.selectedIndex = index;
        self.textValueAlignment = UITextAlignmentRight;
    }
    return self;
}
- (void)dealloc {
    self.dataProvider = nil;
    self.selectedItem = nil;
    [super dealloc];
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    
    QListPickerTableViewCell *cell = (QListPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"QuickformListPickerInlineElement"];
    if (cell==nil){
        cell = [[[QListPickerTableViewCell alloc] init] autorelease];
        [cell setList:self.dataProvider];
    }
    [cell prepareForElement:self inTableView:tableView];
    cell.accessoryType = [self.dataProvider count] > 0 || self.controllerAction!=nil ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return cell;
    
}

- (void)fetchValueIntoObject:(id)obj {
	if (self.key==nil)
		return;
    [obj setValue:self.selectedItem forKey:self.key];
}

@end
