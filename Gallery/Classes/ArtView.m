//
//  ArtView.m
//  Gallery
//
//  Created by Chris Bower on 5/23/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import "ArtView.h"

@implementation ArtView
@synthesize art;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)dealloc {
    [art release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
