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

// TODO: Needs to be rewritten to use a custom UIViewController with the elements in it.
// the animation is not smooth when using the dateselector as a keyboard


#import "QDateTimeElement.h"
#import "QDateTimeInlineElement.h"

@interface QDateTimeElement ()

- (void)initializeRoot;

@end

@implementation QDateTimeElement


@synthesize dateValue;
@synthesize minimumDateValue;
@synthesize maximumDateValue;

- (void)setMode:(UIDatePickerMode)mode {
	_mode = mode;
	[self.sections removeAllObjects];
	[self initializeRoot];
}

- (void)setDateValue:(NSDate *)date {
    [dateValue release];
    dateValue = [date retain];
    [self.sections removeAllObjects];
    [self initializeRoot];
}

- (UIDatePickerMode)mode {
    return _mode;
}

- (QDateTimeElement *)init {
    self = [super init];
    self.grouped = YES;
    _mode = UIDatePickerModeDateAndTime;
    [self initializeRoot];
    return self;
}
- (void)dealloc {
    self.dateValue = nil;
    self.minimumDateValue = nil;
    self.maximumDateValue = nil;
    [super dealloc];
}

- (QDateTimeElement *)initWithTitle:(NSString *)inTitle date:(NSDate *)date {
    self = [self init];
    if (self!=nil){
		self.title = inTitle;
        self.dateValue = date;
        [self initializeRoot];
    }
    return self;
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    UITableViewCell *cell = [super getCellForTableView:tableView controller:controller];

    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    switch (_mode) {
        case UIDatePickerModeDate:
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            break;
        case UIDatePickerModeTime:
            [dateFormatter setDateStyle:NSDateFormatterNoStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            break;
		case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
			break;
    }

    cell.detailTextLabel.text = [dateFormatter stringFromDate:self.dateValue];

    return cell;
}


- (void)initializeRoot {
    NSDate *dateForSection = self.dateValue;
    if (dateForSection==nil){
        dateForSection = NSDate.date;
    }
	QSection *section = [[QSection alloc] initWithTitle:(_mode == UIDatePickerModeDateAndTime ? @"\n" : @"\n\n")];

    if (_mode == UIDatePickerModeDate || _mode == UIDatePickerModeDateAndTime){
        QDateTimeInlineElement *dateElement = [(QDateTimeInlineElement *) [[QDateTimeInlineElement alloc] initWithKey:@"date"] autorelease];
        dateElement.dateValue = dateForSection;
        dateElement.centerLabel = YES;
        dateElement.mode =  UIDatePickerModeDate;
        dateElement.hiddenToolbar = YES;
        [section addElement:dateElement];

    }
    if (_mode == UIDatePickerModeTime || _mode == UIDatePickerModeDateAndTime){
        QDateTimeInlineElement *timeElement = [(QDateTimeInlineElement *) [[QDateTimeInlineElement alloc] initWithKey:@"time"] autorelease];
        timeElement.dateValue = dateForSection;
        timeElement.centerLabel = YES;
        timeElement.mode = UIDatePickerModeTime;
        timeElement.hiddenToolbar = YES;
        [section addElement:timeElement];
    }
    [self addSection:section];
    [section release];
}

- (void)fetchValueIntoObject:(id)obj {
	if (self.key==nil)
		return;
    [obj setValue:self.dateValue forKey:self.key];
}

- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)indexPath {

    if (self.sections==nil)
            return;

    QuickDialogController * newController = [[[QuickDialogController alloc] initWithRoot:self] autorelease];
    newController.selectedTableView.scrollEnabled = NO;
    [controller displayViewController:newController];

	__block QuickDialogController *controllerForBlock = newController;
	
    newController.willDisappearCallback = ^{
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];

        [((QSection *)[controllerForBlock.root.sections objectAtIndex:0]) fetchValueIntoObject:dict];

        NSDate *date = nil;
        NSDate *time = nil;
        if (_mode == UIDatePickerModeTime){
            time = [dict valueForKey:@"time"];
            date = [NSDate date];
        }
        else if (_mode == UIDatePickerModeDate){
            date = [dict valueForKey:@"date"];
            time = [NSDate date];
        }
        else if (_mode == UIDatePickerModeDateAndTime){
            date = [dict valueForKey:@"date"];
            time = [dict valueForKey:@"time"];
        }

        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
        NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond fromDate:time];

        [components setHour:[timeComponents hour]];
        [components setMinute:[timeComponents minute]];
        [components setSecond:[timeComponents second]];
        self.dateValue = [[NSCalendar currentCalendar] dateFromComponents:components];
    };

    [newController.selectedTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

}


@end