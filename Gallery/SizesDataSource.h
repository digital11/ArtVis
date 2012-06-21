//
//  SizesDataSource.h
//  Gallery
//
//  Created by Chris Bower on 6/18/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SizesDataSource : NSObject<UITableViewDelegate, UITableViewDataSource> {
    NSArray *_data;
}
-(id) init:(NSArray *)data;
@end
