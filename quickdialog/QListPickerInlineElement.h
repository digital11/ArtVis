//
//  QListPickerInlineElement.h
//  ZipMark
//
//  Created by Paul Newman on 9/26/11.
//  Copyright (c) 2011 Newman Zone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QEntryElement.h"

@interface QListPickerInlineElement : QEntryElement {

}

@property (nonatomic, retain) NSString *selectedItem;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic) BOOL centerLabel;

- (QListPickerInlineElement *)initWithTitle:(NSString *)string list:(NSArray *)list;
- (QListPickerInlineElement *)initWithTitle:(NSString *)title list:(NSArray *)inList selectedIndex:(NSInteger)index;


@end
