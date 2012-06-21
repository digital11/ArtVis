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

@implementation AppDelegate

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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
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
    if ([[UIScreen screens] count] > 1) {
        [self initAppleTv:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initAppleTv:) name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destroyAppleTv:) name:UIScreenDidDisconnectNotification object:nil];
    
    return YES;
}
- (void)initAppleTv:(NSNotification *)note {
    UIScreen *screen = [[UIScreen screens] objectAtIndex:1];
    screen.overscanCompensation = UIScreenOverscanCompensationInsetApplicationFrame;
    NSLog(@"%@\n%@",screen.preferredMode,screen.availableModes);
    self.tvWindow = [[UIWindow alloc] initWithFrame:screen.applicationFrame];
    _tvWindow.screen = screen;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.tv = [storyboard instantiateViewControllerWithIdentifier:@"tv"];
    _tvWindow.rootViewController = _tv;
    
    [_tvWindow makeKeyAndVisible];
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
