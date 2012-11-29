//
//  AppDelegate.m
//  Gallery
//
//  Created by Chris Bower on 5/21/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import "AppDelegate.h"
#import "AFURLCache.h"
#import "AFJSONRequestOperation.h"
#import "TVViewController.h"
#import "OrientationPickerViewController.h"
#import "SVProgressHUD.h"

@implementation AppDelegate

@synthesize orientationPicker = _orientationPicker;
@synthesize window = _window;
@synthesize artists = _artists;
@synthesize tv = _tv;
@synthesize tvWindow = _tvWindow;
@synthesize artistsDict = _artistsDict;
@synthesize categories = _categories;
@synthesize genres = _genres;
@synthesize sponsors = _sponsors;

- (void)dealloc
{
    [_tvWindow release];
    [_tv release];
    [_artists release];
    [_window release];
    [super dealloc];
}

- (void)fillCache
{
    // Override point for customization after application launch.
    AFURLCache *URLCache = [[[AFURLCache alloc] initWithMemoryCapacity:1024*1024 * 50   // 1MB mem cache
                                                          diskCapacity:1024*1024*500 // 5MB disk cache
                                                              diskPath:[AFURLCache defaultCachePath]] autorelease];
    
	[NSURLCache setSharedURLCache:URLCache];
    
    NSURL *url = [NSURL URLWithString:API(@"art/get_artists/")];//API(@"api=getARTFEATURE&gridblocks=15")];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        self.artistsDict = [NSMutableDictionary dictionary];
        self.artists = [JSON objectForKey:@"posts"];
        for (NSDictionary *dict in self.artists) {
            [self.artistsDict setObject:dict forKey:[NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]]];
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
    url = [NSURL URLWithString:API(@"art/get_categories/")];//API(@"api=getARTFEATURE&gridblocks=15")];
    req = [NSURLRequest requestWithURL:url];
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        self.categories = [JSON objectForKey:@"categories"];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
    url = [NSURL URLWithString:API(@"art/get_genres/")];//API(@"api=getARTFEATURE&gridblocks=15")];
    req = [NSURLRequest requestWithURL:url];
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        self.genres = [JSON objectForKey:@"categories"];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
    url = [NSURL URLWithString:API(@"art/get_sponsors/")];//API(@"api=getARTFEATURE&gridblocks=15")];
    req = [NSURLRequest requestWithURL:url];
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        self.sponsors = [JSON objectForKey:@"posts"];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [SVProgressHUD showWithStatus:@"Fetching Application Settings" maskType:SVProgressHUDMaskTypeGradient];
//    [SVProgressHUD showProgress:.25f status:@"Fetching Application Settings" maskType:SVProgressHUDMaskTypeGradient];
    NSURL *url2 = [NSURL URLWithString:API(@"art/get_last_update/")];//API(@"api=getARTFEATURE&gridblocks=15")];
    NSURLRequest *req2 = [NSURLRequest requestWithURL:url2];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:req2 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        int last = [[NSUserDefaults standardUserDefaults] integerForKey:@"last_update"];
        if (last < [[JSON objectForKey:@"last"] intValue]) {
            [[NSUserDefaults standardUserDefaults] setInteger:[[JSON objectForKey:@"last"] intValue] forKey:@"last_update"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self fillCache];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"Loaded"];
        }
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [SVProgressHUD showSuccessWithStatus:@"Using Local Data"];
    }];
    [op start];
    [op waitUntilFinished];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initAppleTv:) name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destroyAppleTv:) name:UIScreenDidDisconnectNotification object:nil];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.orientationPicker = [storyboard instantiateViewControllerWithIdentifier:@"orientation"];
    //
    if ([[UIScreen screens] count] > 1) {
        [self performSelector:@selector(initAppleTv:) withObject:nil afterDelay:1];
    }
    
    return YES;
}
- (void)showTv:(BOOL)portrait {
    UIScreen *screen = [[UIScreen screens] objectAtIndex:1];
    
    
    
    CGRect        screenBounds = screen.bounds;
    

    
    screen.overscanCompensation = UIScreenOverscanCompensationScale;
    NSLog(@"%@\n%@",screen.preferredMode,screen.availableModes);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-400, -400, 9000, 9000)];
    view.backgroundColor = [UIColor redColor];
    
    self.tvWindow = [[UIWindow alloc] initWithFrame:screen.bounds];
    _tvWindow.screen = screen;
    _tvWindow.frame = screenBounds;
    _tvWindow.clipsToBounds = YES;
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.tv = [storyboard instantiateViewControllerWithIdentifier:@"tv"];
    self.tv.isPortrait = portrait;
    self.tv.noGrid = YES;
    self.tv.view.clipsToBounds = YES;
    _tvWindow.rootViewController = _tv;
    
    
    [_tvWindow makeKeyAndVisible];
    
//    UIView *calib = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _window.rootViewController.view.frame.size.width, _window.rootViewController.view.frame.size.height)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 1000, 100)];
//    label.backgroundColor = [UIColor redColor];
//    label.textColor = [UIColor blackColor];
//    label.tag = 555;
//    calib.backgroundColor = [UIColor greenColor];
//    [_tvWindow addSubview:label];
//    [_window.rootViewController.view addSubview:calib];
//    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    [calib addGestureRecognizer:pan];
//    
//    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
//    [calib addGestureRecognizer:pinch];
//    
//    _origH = self.tv.view.frame.size.height;
//    _origW = self.tv.view.frame.size.width;
//    _lastScale = 1.0;
//    _currentScale = 1.0;
    
}
- (void)pinch:(UIPinchGestureRecognizer *)gesture {

    if ([gesture state] == UIGestureRecognizerStateEnded) {
        _lastScale = 1.0;
        _origH = self.tv.view.frame.size.height;
        _origW = self.tv.view.frame.size.width;
    }
    if ([gesture state] == UIGestureRecognizerStateBegan || [gesture state] == UIGestureRecognizerStateChanged) {
        _currentScale += [gesture scale] - _lastScale;

        _lastScale = [gesture scale];
        
        CGRect frame = self.tv.view.frame;
        frame.size.width = _origW + (_origW * _currentScale);
        frame.size.height = _origH + (_origH * _currentScale);
        self.tv.view.frame = frame;
        
        [(UILabel*)[_tvWindow viewWithTag:555] setText:[NSString stringWithFormat:@"Scale: %f - Frame: %@",_currentScale,NSStringFromCGRect(self.tv.view.frame)]];
    }
}
-(void)pan:(UIPanGestureRecognizer *)gesture {
    if ([gesture state] == UIGestureRecognizerStateBegan || [gesture state] == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:[gesture.view superview]];
        [self.tv.view setCenter:CGPointMake([self.tv.view center].x + translation.x, [self.tv.view center].y+translation.y*0.1)];
        
        [gesture setTranslation:CGPointZero inView:[gesture.view superview]];
        
        [(UILabel*)[_tvWindow viewWithTag:555] setText:NSStringFromCGRect(self.tv.view.frame)];
    }
}
- (void)initAppleTv:(NSNotification *)note {
    [_window.rootViewController.view addSubview:_orientationPicker.view];
}
- (void)destroyAppleTv:(NSNotification *)note {
    self.tv = nil;
    self.tvWindow = nil;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
+ (AppDelegate*) sharedAppDelegate {
	return (AppDelegate*) [UIApplication sharedApplication].delegate;
}
+ (NSDictionary *) getArtist:(int)byId {
    return [[[AppDelegate sharedAppDelegate] artistsDict] objectForKey:[NSNumber numberWithInt:byId]];
}
+ (void) showFullTv:(NSDictionary *)art {
    [[AppDelegate sharedAppDelegate].tv showFullTv:art];
}
+ (void) hideFullTv {
    [[AppDelegate sharedAppDelegate].tv hideFullTv];    
}
@end
