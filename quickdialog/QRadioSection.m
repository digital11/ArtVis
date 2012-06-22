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
#import "QRadioSection.h"
#import "QRootElement.h"
#import "QRadioItemElement.h"

@implementation QRadioSection

@synthesize selected;


- (void)createElements {

    for (NSUInteger i=0; i< [_items count]; i++){
        [self addElement:[[[QRadioItemElement alloc] initWithIndex:i RadioSection:self] autorelease]];
    }
}

- (NSArray *)items {
    return _items;
}

- (void)setItems:(NSArray *)items {
    [_items release];
    _items = items;
    [self createElements];
}

- (QRadioSection *)initWithItems:(NSArray *)stringArray selected:(NSUInteger)inSelected {
    self = [super init];
    if (self!=nil){
        self.items = stringArray;
        self.selected = inSelected;
        [self createElements];
    }
    return self;
}

- (QRadioSection *)initWithItems:(NSArray *)stringArray selected:(NSUInteger)inSelected title:(NSString *)title {
    self = [self initWithItems:stringArray selected:inSelected];
    self.title = title;
    return self;
}
- (void)dealloc {
    self.items = nil;
    [super dealloc];
}

- (void)fetchValueIntoObject:(id)obj {
    if (self.key==nil)
		return;
    [obj setValue:[NSNumber numberWithInteger:_selected] forKey:self.key];
}


@end