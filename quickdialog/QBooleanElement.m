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

#import "QBooleanElement.h"
#import "QuickDialogTableView.h"

@implementation QBooleanElement

@synthesize onImage;
@synthesize offImage;
@synthesize boolValue;
@synthesize enabled;


- (QBooleanElement *)init {
    self = [self initWithTitle:nil BoolValue:YES];
    return self;
}

- (id)initWithTitle:(NSString *)title BoolValue:(BOOL)value {
    self = [self initWithTitle:title Value:nil];
    self.boolValue = value;
    self.enabled = YES;
    return self;
}
- (void)dealloc {
    self.onImage = nil;
    self.offImage = nil;
    [super dealloc];
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    UITableViewCell *cell = [super getCellForTableView:tableView controller:controller];
    cell.accessoryType = self.sections!= nil || self.controllerAction!=nil ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.selectionStyle = self.sections!= nil || self.controllerAction!=nil ? UITableViewCellSelectionStyleBlue: UITableViewCellSelectionStyleNone;
    
    if ((self.onImage==nil) && (self.offImage==nil))  {
        UISwitch *boolSwitch = [[[UISwitch alloc] init] autorelease];
        boolSwitch.on = self.boolValue;
        boolSwitch.enabled = self.enabled;
        [boolSwitch addTarget:self action:@selector(switched:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = boolSwitch;

    } else {
        UIImageView *boolSwitch = [[[UIImageView alloc] initWithImage: self.boolValue ? self.onImage : self.offImage] autorelease];
        cell.accessoryView = boolSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }

    return cell;
}

- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.boolValue = !self.boolValue;
    if ([cell.accessoryView class] == [UIImageView class]){
        ((UIImageView *)cell.accessoryView).image =  self.boolValue ? self.onImage   : self.offImage;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)switched:(id)boolSwitch {
    self.boolValue = ((UISwitch *)boolSwitch).on;
}

- (void)fetchValueIntoObject:(id)obj {
	if (self.key==nil)
		return;
    [obj setValue:[NSNumber numberWithBool:self.boolValue] forKey:self.key];
}


@end