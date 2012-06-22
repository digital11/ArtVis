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
#import "QEntryTableViewCell.h"
#import "QDateEntryTableViewCell.h"
#import "UIView+QuickAnimations.h"

@interface QuickDialogTableView ()

@property(nonatomic, retain) QuickDialogController *controller;
@property(nonatomic, retain) id quickformDataSource;
@property(nonatomic, retain) id quickformDelegate;

@end

@implementation QuickDialogTableView

@synthesize root;
@synthesize selectedCell;
@synthesize styleProvider;
@synthesize controller;
@synthesize quickformDataSource;
@synthesize quickformDelegate;
@synthesize customSeparatorImage;
@synthesize requiredIconImage;

- (id)initWithController:(QuickDialogController *)inController {
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0) style:inController.root.grouped ? UITableViewStyleGrouped : UITableViewStylePlain];
    if (self!=nil){
        self.controller = inController;
        self.root = self.controller.root;
        self.customSeparatorImage = nil;

        quickformDataSource = [[QuickDialogDataSource alloc] initForTableView:self];
        self.dataSource = quickformDataSource;

        quickformDelegate = [[QuickDialogTableDelegate alloc] initForTableView:self];
        self.delegate = quickformDelegate;
    }
    return self;
}
- (void)dealloc {
    self.root = nil;
    self.selectedCell = nil;
    self.styleProvider = nil;
    self.controller = nil;
    self.quickformDataSource = nil;
    self.quickformDelegate = nil;
    self.customSeparatorImage = nil;
    self.requiredIconImage = nil;
    [super dealloc];
}

-(void)setRoot:(QRootElement *)inRoot{
    [root release];
    root = [inRoot retain];
    for (QSection *section in self.root.sections) {
        if (section.needsEditing == YES){
            [self setEditing:YES animated:YES];
            self.allowsSelectionDuringEditing = YES;
        }
    }
    [self reloadData];
}

- (UITableViewCell *)cellForElement:(QElement *)element {
    for (int i=0; i< [self.root.sections count]; i++){
        QSection * currSection = [self.root.sections objectAtIndex:(NSUInteger) i];

        for (int j=0; j< [currSection.elements count]; j++){
            QElement *currElement = [currSection.elements objectAtIndex:(NSUInteger) j];
            if (currElement == element){
                NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:i];
                return [self cellForRowAtIndexPath:path];
            }
        }
    }

    return NULL;
}

- (void)viewWillAppear {

    NSArray *selected = nil;
    if ([self indexPathForSelectedRow]!=nil){
        NSIndexPath *selectedRowIndex = [self indexPathForSelectedRow];
        selected = [NSArray arrayWithObject:selectedRowIndex];
        [self reloadRowsAtIndexPaths:selected withRowAnimation:NO];
        [self selectRowAtIndexPath:selectedRowIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self deselectRowAtIndexPath:selectedRowIndex animated:YES];
    };
}

- (void)setCustomSeparatorImage:(UIImage *)inCustomSeparatorImage {
    if (customSeparatorImage != nil)
        [customSeparatorImage release];
    customSeparatorImage = [inCustomSeparatorImage retain];
    self.separatorColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (BOOL)allRequiredFieldsFilledIn {
    for (QSection *section in self.root.sections) {
        BOOL allFieldsFilledIn = YES;
        for (QEntryElement *element in section.elements) {
            
            if (element.isRequired) {
                if ([element isKindOfClass:[QDateTimeInlineElement class]]) {
                    QDateEntryTableViewCell *cell = (QDateEntryTableViewCell *)[self cellForElement:element]; 
                    QDateTimeInlineElement *dateElement = (QDateTimeInlineElement *)element;
                    if (dateElement.dateValue == nil) {
                        dateElement.isInError = YES;
                        [cell showErrorButton];
                        if (allFieldsFilledIn)
                            allFieldsFilledIn = NO;
                    }
                }
                else {
                    QEntryTableViewCell *cell = (QEntryTableViewCell *)[self cellForElement:element];
                    QEntryElement *entryElement = (QEntryElement *)element;
                    if(entryElement.textValue == nil || [entryElement.textValue isEqualToString:@""]) {
                        entryElement.isInError = YES;
                        [cell showErrorButton];
                        if (allFieldsFilledIn)
                            allFieldsFilledIn = NO;
                    }
                }
            }
        }
        if (!allFieldsFilledIn) {
            [self shakeView];
            return NO;
        }
    }
    return YES;
}

- (void)clearErrorImagesFromRequiredFields {
    for (QSection *section in self.root.sections) {
        for (QEntryElement *element in section.elements) {
            if (element.isRequired) {
                if ([element isKindOfClass:[QDateTimeInlineElement class]]) {
                    QDateEntryTableViewCell *cell = (QDateEntryTableViewCell *)[self cellForElement:element];
                    QDateTimeInlineElement *dateElement = (QDateTimeInlineElement *)element;
                    if(dateElement.dateValue == nil) {
                        dateElement.isInError = NO;
                        [cell hideErrorButton];
                    }
                }
                else {
                    QEntryTableViewCell *cell = (QEntryTableViewCell *)[self cellForElement:element];
                    QEntryElement *entryElement = (QEntryElement *)element;
                    if(entryElement.textValue == nil || [entryElement.textValue isEqualToString:@""]) {
                        entryElement.isInError = NO;
                        [cell hideErrorButton];
                    }
                }
            }
                
        }
    }
}

@end