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

#import "QElement.h"
#import "QRootElement.h"

@implementation QRootElement

@synthesize title;
@synthesize sections;
@synthesize grouped;
@synthesize controllerName;

- (id) init {
    self = [super init];
    if(self) {
        self.sections = [[[NSMutableArray alloc] init] autorelease]; 
        self.cellTopBottomMargin = 11.f;
    }
    return self;
}
- (void)dealloc {
    self.title = nil;
    self.sections = nil;
    self.controllerName = nil;
    [super dealloc];
}
- (void)addSection:(QSection *)section {
   [self.sections addObject:section];
    section.rootElement = self;
}

- (QSection *)getSectionForIndex:(NSInteger)index {
   return [self.sections objectAtIndex:(NSUInteger) index];
}

- (NSInteger)numberOfSections {
    return [self.sections count];
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    UITableViewCell *cell = [super getCellForTableView:tableView controller:controller];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = self.title;
    return cell;
}

- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)path {
    [super selected:tableView controller:controller indexPath:path];
	[tableView deselectRowAtIndexPath:path animated:YES];
    if (self.sections.count==0)
            return;

    [controller displayViewControllerForRoot:self];
}

- (void)fetchValueIntoObject:(id)obj {
    for (QSection *s in self.sections){
        for (QElement *el in s.elements) {
            [el fetchValueIntoObject:obj];
        }
    }
}


@end