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

#import "QBadgeTableCell.h"

@interface QBadgeTableCell ()

@property (nonatomic,retain) UILabel *badgeLabel;

@end

@implementation QBadgeTableCell

@synthesize badgeColor;
@synthesize badgeLabel;


- (QBadgeTableCell *)init {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QuickformBadgeElement"];
    if (self){
        self.badgeColor = [UIColor colorWithRed:0.530f green:0.600f blue:0.738f alpha:1.000f];
        self.badgeLabel = [[[UILabel alloc] init] autorelease];
        [self.contentView addSubview:self.badgeLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.badgeLabel.backgroundColor = self.badgeColor;
        self.badgeLabel.textColor = [UIColor whiteColor];
        self.badgeLabel.backgroundColor = [UIColor clearColor];
        self.badgeLabel.textAlignment = UITextAlignmentCenter;
        self.badgeLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return self;
}

- (void)dealloc {
    self.badgeColor = nil;
    self.badgeLabel = nil;
    [super dealloc];
}

- (void) drawRect:(CGRect)rect
{	
    [self.badgeLabel sizeToFit];
    self.badgeLabel.frame= CGRectMake(self.contentView.frame.size.width - self.badgeLabel.frame.size.width - self.badgeLabel.frame.size.height, 12, self.badgeLabel.frame.size.width,  self.badgeLabel.frame.size.height);
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	float radius = self.badgeLabel.frame.size.height / 2.0f;
    
	CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [self.badgeColor CGColor]);
	CGContextBeginPath(context);
	CGContextAddArc(context, self.badgeLabel.frame.origin.x , self.badgeLabel.frame.origin.y + radius, radius, (CGFloat)M_PI_2 , 3.0f * (CGFloat)M_PI_2, NO);
	CGContextAddArc(context, self.badgeLabel.frame.origin.x + self.badgeLabel.frame.size.width, self.badgeLabel.frame.origin.y + radius, radius, 3.0f * (CGFloat)M_PI_2, (CGFloat)M_PI_2, NO);
	CGContextClosePath(context);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
}

@end