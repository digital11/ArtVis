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

#import "QTextElement.h"

@implementation QTextElement

@synthesize text;
@synthesize font;
@synthesize color;

- (id)init {
	self = [super init];
	if (self) {
		self.text = @"";
		self.font = [UIFont systemFontOfSize:14];
		self.color = [UIColor blackColor];
	}
	return self;
}
- (id)initWithKey:(NSString *)inKey {
    self = [super initWithKey:inKey];
    self.text = @"";
	self.font = [UIFont systemFontOfSize:14];
	self.color = [UIColor blackColor];
    return self;
	
}
- (id)initWithText:(NSString *)inText {
    self = [self init];
    if (self) {
		self.text = inText;
	}
    return self;
}
- (void)dealloc {
    self.text = nil;
    self.font = nil;
    self.color = nil;
    [super dealloc];
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuickfromTextElement"];
    if (cell==nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuickfromTextElement"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.font = self.font;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = self.color;
    cell.textLabel.text = self.text;
    cell.accessoryType = [self.sections count] > 0 || self.controllerAction!=nil ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.selectionStyle = [self.sections count] > 0 || self.controllerAction!=nil ? UITableViewCellSelectionStyleBlue: UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)indexPath {
    [super selected:tableView controller:controller indexPath:indexPath];
}

- (CGFloat)getRowHeightForTableView:(QuickDialogTableView *)tableView {

    if (!mUseCellHeight) {
        if (self.text==nil || self.text == @""){
            return [super getRowHeightForTableView:tableView];
        }
        CGSize constraint = CGSizeMake(300, 20000);
        CGSize  size= [self.text sizeWithFont:self.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        return size.height+20;
    }
    else {
        return [super getRowHeightForTableView:tableView];
    }
}

@end