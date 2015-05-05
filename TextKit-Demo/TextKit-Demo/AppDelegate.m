//
//  AppDelegate.m
//  TextKit-Demo
//
//  Created by luowei on 15/5/4.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import "AppDelegate.h"
#import "TKDConfigrationViewController.h"
#import "TKDHighlightingViewController.h"
#import "TKDLayoutingViewController.h"
#import "TKDInteractionViewController.h"

@interface AppDelegate ()

@property(nonatomic, strong) UITabBarController *tabController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.tabController = [[UITabBarController alloc] init];

    TKDConfigrationViewController *configrationViewController = [TKDConfigrationViewController new];
    UINavigationController *navigationController = [UINavigationController new];
    [navigationController addChildViewController:configrationViewController];
    navigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:100];

    TKDHighlightingViewController *highlightingViewController = [TKDHighlightingViewController new];
    highlightingViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:101];

    TKDLayoutingViewController *layoutingViewController = [TKDLayoutingViewController new];
    layoutingViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:102];

    TKDInteractionViewController *interactionViewController = [TKDInteractionViewController new];
    interactionViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:103];

    self.tabController.viewControllers =@[navigationController,highlightingViewController,layoutingViewController,interactionViewController];

    self.window.rootViewController = self.tabController;

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
