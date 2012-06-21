//
//  ArtistDataSource.h
//  Gallery
//
//  Created by Chris Bower on 6/18/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistDataSource : NSObject<UITableViewDelegate, UITableViewDataSource> {
    NSArray *_data;
}

@end
