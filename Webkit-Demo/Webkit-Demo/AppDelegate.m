//
//  AppDelegate.m
//  Webkit-Demo
//
//  Created by luowei on 15/4/28.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "BSViewController.h"

@interface AppDelegate () <UINavigationControllerDelegate,
//        UITabBarControllerDelegate,
        UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UINavigationController *navigationController;
@property(nonatomic, strong) UITabBarController *tabBarController;
@property(nonatomic, strong) UITableViewController *tableViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

/*
    //添加tabBarController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *viewController1 = storyboard.instantiateInitialViewController;;
    viewController1.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:0];
//    viewController1.tabBarItem.title = @"OC&JS互调";

    UINavigationController *viewController2 = [[UINavigationController alloc] initWithRootViewController:[BSViewController new]];
    viewController2.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:1];
//    viewController2.tabBarItem.title = @"SimpleBroser";

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2];
    self.tabBarController.delegate = self;
    self.window.rootViewController = self.tabBarController;
*/
    self.tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.tableViewController.tableView.delegate = self;
    self.tableViewController.tableView.dataSource = self;

    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.tableViewController];
    self.window.rootViewController = self.navigationController;
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[BSViewController new]];

    [_window makeKeyAndVisible];
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

//ViewController Delegate 实现

/*
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

    //给TabBar设置过渡动画
    //set up crossfade transition
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    //apply transition to tab bar controller's view
    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"OC与JS交互之Skinnable视图";
            break;
        case 1:
            cell.textLabel.text = @"SimpleBroser简单浏览器";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [self.tableViewController.tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController,*broserViewController;

    switch (indexPath.row){
        case 0:
            viewController = storyboard.instantiateInitialViewController;
            viewController.edgesForExtendedLayout = UIRectEdgeNone;
            [self.tableViewController.navigationController pushViewController:viewController animated:YES];
            break;
        case 1:
            broserViewController = [BSViewController new];
            [self.tableViewController.navigationController pushViewController:broserViewController animated:YES];
            break;
        default:
            break;
    }
}


@end
