//
//  AppDelegate.m
//  TabAndTable
//
//  Created by luowei on 15/5/19.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import "AppDelegate.h"
#import "KeyBoardTypeViewController.h"
#import "ReturnTypeViewController.h"
#import "ViewController.h"
#import "SqliteViewController.h"
#import "CoreDataViewController.h"
#import "FMDBViewController.h"
#import "MenuItemsVC.h"
#import "TabAndTable-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    ViewController *viewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    viewController.title = @"输入框类型";
    viewController.view.backgroundColor = [UIColor whiteColor];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:10];
    
    SqliteViewController *sqliteController = [SqliteViewController new];
    sqliteController.title = @"sqlite数据操作范例";
    sqliteController.view.backgroundColor = [UIColor lightGrayColor];
    sqliteController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:11];
    
    CoreDataViewController *coreDataController= [CoreDataViewController new];
    coreDataController.title = @"CoreData数据操作范例";
    coreDataController.view.backgroundColor = [UIColor grayColor];
    coreDataController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:12];

    FMDBViewController *fmdbController= [FMDBViewController new];
    fmdbController.title = @"FMDB数据操作范例";
    fmdbController.view.backgroundColor = [UIColor grayColor];
    fmdbController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:13];
    
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:viewController];
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:sqliteController];
    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:coreDataController];
    UINavigationController *navigationController4 = [[UINavigationController alloc] initWithRootViewController:fmdbController];

    tabBarController.viewControllers = @[navigationController1,navigationController2,navigationController3,navigationController4];

//    //侧滑菜单
//    MenuItemsVC *sideMenuVC = [MenuItemsVC new];
//    ENSideMenuNavigationController *navVC = [[ENSideMenuNavigationController alloc]initWithMenuViewController:sideMenuVC contentViewController:tabBarController];
//
//    //toggle side menu
//    UIBarButtonItem *toggleButton = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStylePlain target:tabBarController action:@selector(toggleSideMenuView)];
//    [tabBarController.navigationItem setLeftBarButtonItem:toggleButton];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tabBarController;//navVC;
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
