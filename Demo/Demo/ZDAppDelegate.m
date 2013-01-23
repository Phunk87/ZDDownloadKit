//
//  ZDAppDelegate.m
//  Demo
//
//  Created by Oneday on 13-1-22.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import "ZDAppDelegate.h"
#import "ZDDemoViewController.h"

@implementation ZDAppDelegate

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        ZDDemoViewController *demoViewController = [[[ZDDemoViewController alloc] initWithNibName:@"ZDDemoViewController" bundle:nil] autorelease];
        self.navigationController = [[[UINavigationController alloc] initWithRootViewController:demoViewController] autorelease];
        
        self.window.rootViewController = self.navigationController;
    } else {
        ZDDemoViewController *demoViewController = [[[ZDDemoViewController alloc] initWithNibName:@"ZDDemoViewController~iPad" bundle:nil] autorelease];
        self.navigationController = [[[UINavigationController alloc] initWithRootViewController:demoViewController] autorelease];
        
        self.window.rootViewController = self.navigationController;
    }
    [self.window makeKeyAndVisible];
    return YES;
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

@end
