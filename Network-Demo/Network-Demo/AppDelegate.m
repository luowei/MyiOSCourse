//
//  AppDelegate.m
//  CFNetWork-Demo
//
//  Created by luowei on 15/5/7.
//
//

#import "AppDelegate.h"
#import "LoadingPic.h"
#import "BackgroundTransferViewController.h"

@interface AppDelegate () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableViewController *tableViewController;
@property(nonatomic, strong) UINavigationController *navigationController;
@end

@implementation AppDelegate

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler {
    BLog();
    /*
     Store the completion handler. The completion handler is invoked by the view controller's
     checkForAllDownloadsHavingCompleted method (if all the download tasks have been completed).
     */
    self.backgroundSessionCompletionHandler = completionHandler;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BLog();
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    _tableViewController.tableView.dataSource = self;
    _tableViewController.tableView.delegate = self;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:_tableViewController];
    
    self.window.rootViewController = _navigationController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    BLog();
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    BLog();
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    BLog();
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    BLog();
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    BLog();
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark UITableViewDataSource Implement

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.row){
        case 0:{
            cell.textLabel.text = [NSString stringWithUTF8String:class_getName([LoadingPic class])];
            break;
        }
        case 1:{
            cell.textLabel.text = [NSString stringWithUTF8String:class_getName([BackgroundTransferViewController class])];
            break;
        }
        case 2:{
            
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row){
        case 0:{
            UIViewController *viewController = [UIViewController new];
            viewController.title = cell.textLabel.text;
            viewController.view.backgroundColor = [UIColor whiteColor];
            [viewController.view addSubview:[[LoadingPic alloc]initWithFrame:CGRectMake(100, 100, 200, 100)
                                                                         url:@"http://a.hiphotos.baidu.com/image/pic/item/d50735fae6cd7b8966cae5c20d2442a7d8330ec9.jpg"]];
            [viewController.view addSubview:[[LoadingPic alloc]initWithFrame:CGRectMake(100, 300, 200, 100)
                                                                         url:@"https://www.baidu.com/img/bdlogo.png"]];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 1:{
            BackgroundTransferViewController *viewController = [BackgroundTransferViewController new];
            viewController.title = cell.textLabel.text;
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 2:{
            
            break;
        }
        default:
            break;
    }
    
}

@end
