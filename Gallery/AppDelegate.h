//
//  AppDelegate.h
//  Gallery
//
//  Created by Chris Bower on 5/21/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TVViewController;
@class OrientationPickerViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    float _origW;
    float _origH;
    float _lastScale;
    float _currentScale;
}

@property (strong, nonatomic) OrientationPickerViewController *orientationPicker;
@property (strong, nonatomic) NSArray *sponsors;
@property (strong, nonatomic) NSArray *artists;
@property (strong, nonatomic) NSMutableDictionary *artistsDict;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *genres;
@property (strong, nonatomic) UIWindow *window;
@property (strong, atomic) UIWindow *tvWindow;
@property (strong, atomic) TVViewController *tv;

+ (AppDelegate*) sharedAppDelegate;
+ (NSDictionary *) getArtist:(int)byId;
+ (void) showFullTv:(NSDictionary *)art;
+ (void) hideFullTv;
- (void) showTv:(BOOL)portrait;
@end
