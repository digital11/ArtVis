//
//  PagingGridViewController.h
//  Gallery
//
//  Created by Chris Bower on 6/18/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagingGridViewController  : UIViewController<UIScrollViewDelegate> {
    NSMutableString *_url;
    BOOL _inited;
    int _page;
    int _numPages;
    NSMutableArray *_pages;
}
- (id)initWithFrame:(CGRect)frame andQuery:(NSDictionary *)query;

@property (nonatomic, strong) UIScrollView *scroller;
@end
