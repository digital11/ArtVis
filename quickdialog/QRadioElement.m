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

#import "QRootElement.h"
#import "QRadioElement.h"
#import "QRadioItemElement.h"


@interface QRadioElement ()

@property(nonatomic, retain) NSArray *items;

@end

@implementation QRadioElement {

}

@synthesize selected;
@synthesize values;
@synthesize items;


- (void)createElements {
    [self.sections removeAllObjects];
    self.parentSection = [[[QSection alloc] init] autorelease];
    
    [self addSection:self.parentSection];

    for (NSUInteger i=0; i< [self.items count]; i++){
        [self.parentSection addElement:[[[QRadioItemElement alloc] initWithIndex:i RadioElement:self] autorelease]];
    }
}

- (QRadioElement *)initWithItems:(NSArray *)stringArray selected:(NSUInteger)inSelected {
    self = [self initWithItems:stringArray selected:inSelected title:nil];
    return self;
}

- (QRadioElement *)initWithItems:(NSArray *)stringArray selected:(NSUInteger)inSelected title:(NSString *)title {
    self = [super init];
    if (self!=nil){
        self.items = stringArray;
        self.selected = inSelected;
        [self createElements];
        self.title = title;
    }
    return self;
}

-(void)dealloc {
    self.items = nil;
    self.values = nil;
    [super dealloc];
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    UITableViewCell *cell = [super getCellForTableView:tableView controller:controller];

    NSString *selectedValue = nil;
    if (self.selected >= 0 && self.selected < self.items.count)
        selectedValue = [[self.items objectAtIndex:self.selected] description];

    if (self.title == NULL){
        cell.textLabel.text = selectedValue;
        cell.detailTextLabel.text = nil;
        cell.imageView.image = nil;
    } else {
        cell.textLabel.text = self.title;
        cell.detailTextLabel.text = selectedValue;
        cell.imageView.image = nil;
    }
    return cell;
}

- (void)fetchValueIntoObject:(id)obj {
	if (self.key==nil)	
		return;

    if (self.selected < 0 || self.selected >= (self.values != nil ? self.values : self.items).count)
        return;

    if (self.values==nil){
        [obj setObject:[NSNumber numberWithInt:self.selected] forKey:self.key];
    } else {
        [obj setObject:[self.values objectAtIndex:self.selected] forKey:self.key];
    }
}



@end