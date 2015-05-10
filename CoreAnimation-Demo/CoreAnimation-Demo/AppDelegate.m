//
//  AppDelegate.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/11.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import <objc/runtime.h>

#import "AppDelegate.h"
#import "ViewController.h"
#import "ContentRectViewController.h"
#import "ClickViewController.h"
#import "HitTestViewController.h"
#import "ShadowViewController.h"
#import "MaskViewController.h"
#import "NearestViewController.h"
#import "GroupOpacityViewController.h"
#import "TransformViewController.h"
#import "Transform3dViewController.h"
#import "Cube3dViewController.h"
#import "ImplicitAnimationViewController.h"
#import "PresentationViewController.h"
#import "BasicAnimationViewController.h"
#import "KeyFrameAnimationViewController.h"
#import "BezierAnimationViewController.h"
#import "TransitionViewController.h"
#import "StopAnimationViewController.h"
#import "ShapeLayerViewController.h"
#import "TextLayerViewController.h"
#import "TransformLayerViewController.h"
#import "GradientLayerViewController.h"
#import "ReplicatorLayerViewController.h"
#import "TiledLayerViewController.h"
#import "MediaTimingViewController.h"
#import "OpenDoorViewController.h"
#import "RelativeTimeViewController.h"
#import "MediaTimingFunctionViewController.h"
#import "ReboundBallViewController.h"
#import "DrawViewController.h"
#import "ChipmunkViewController.h"
#import "OptimizeViewController.h"
#import "ImageIOViewController.h"
#import "CollectionScrollViewController.h"
#import "CollectionTiledLayerViewController.h"
#import "PVRImageViewController.h"
#import "Matrix3DViewController.h"
#import "EmitterLayerViewController.h"
#import "EAGLLayerViewController.h"
#import "PlayerLayerViewController.h"

@interface AppDelegate ()<UITabBarControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
    BOOL showToolBar;
}

@property(nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    self.window.rootViewController = storyboard.instantiateInitialViewController;

//    self.window.rootViewController = [ShapeLayerViewController new];
//    self.window.rootViewController = [MaskViewController new];
//    self.window.rootViewController = [ContentRectViewController new];
//    self.window.rootViewController = [ClickViewController new];
//    self.window.rootViewController = [HitTestViewController new];
//    self.window.rootViewController = [ShadowViewController new];
//    self.window.rootViewController = [MaskViewController new];
//    self.window.rootViewController = [NearestViewController new];
//    self.window.rootViewController = [GroupOpacityViewController new];
//    self.window.rootViewController = [TransformViewController new];
//    self.window.rootViewController = [Transform3dViewController new];
//    self.window.rootViewController = [Cube3dViewController new];
//    self.window.rootViewController = [ImplicitAnimationViewController new];
//    self.window.rootViewController = [PresentationViewController new];
//    self.window.rootViewController = [BasicAnimationViewController new];
//    self.window.rootViewController = [KeyFrameAnimationViewController new];
//    self.window.rootViewController = [BezierAnimationViewController new];
//    self.window.rootViewController = [TransitionViewController new];
//    self.window.rootViewController = [StopAnimationViewController new];
//    self.window.rootViewController = [ShapeLayerViewController new];
//    self.window.rootViewController = [TextLayerViewController new];
//    self.window.rootViewController = [TransformLayerViewController new];
//    self.window.rootViewController = [GradientLayerViewController new];
//    self.window.rootViewController = [ReplicatorLayerViewController new];
//    self.window.rootViewController = [TiledLayerViewController new];
//    self.window.rootViewController = [MediaTimingViewController new];
//    self.window.rootViewController = [OpenDoorViewController new];
//    self.window.rootViewController = [RelativeTimeViewController new];
//    self.window.rootViewController = [MediaTimingFunctionViewController new];
//    self.window.rootViewController = [ReboundBallViewController new];
//    self.window.rootViewController = [DrawViewController new];
//    self.window.rootViewController = [ChipmunkViewController new];
//    self.window.rootViewController = [OptimizeViewController new];
//    self.window.rootViewController = [ImageIOViewController new];
//    self.window.rootViewController = [CollectionScrollViewController new];
//    self.window.rootViewController = [CollectionTiledLayerViewController new];
//    self.window.rootViewController = [PVRImageViewController new];
//    self.window.rootViewController = [Matrix3DViewController new];

//    self.window.rootViewController = [TransitionViewController new];
//    self.window.rootViewController = [ClickViewController new];



    //添加tabBar
    UITableViewController *tableViewController1 = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    tableViewController1.tableView.dataSource = self;
    tableViewController1.tableView.delegate = self;
    self.navViewController1 = [[UINavigationController alloc] initWithRootViewController:tableViewController1];
    self.navViewController1.title = @"Layer";
    self.navViewController1.tabBarItem.title = @"图层(Layer)相关";
    self.navViewController1.tabBarItem.image = [UIImage imageNamed:@"aa"];

    UITableViewController *tableViewController2 = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    tableViewController2.tableView.dataSource = self;
    tableViewController2.tableView.delegate = self;
    self.navViewController2 = [[UINavigationController alloc] initWithRootViewController:tableViewController2];
    self.navViewController2.title = @"Annimation";
    self.navViewController2.tabBarItem.title = @"动画(Annimation)相关";
    self.navViewController2.tabBarItem.image = [UIImage imageNamed:@"bb"];

    UITableViewController *tableViewController3 = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    tableViewController3.tableView.dataSource = self;
    tableViewController3.tableView.delegate = self;
    self.navViewController3 = [[UINavigationController alloc] initWithRootViewController:tableViewController3];
    self.navViewController3.title = @"Performance";
    self.navViewController3.tabBarItem.title = @"性能(Performance)相关";
    self.navViewController3.tabBarItem.image = [UIImage imageNamed:@"aa"];
    

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[self.navViewController1, self.navViewController2, self.navViewController3];
    self.tabBarController.delegate = self;
    self.window.rootViewController = self.tabBarController;

    UIScreenEdgePanGestureRecognizer *screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(showToolBar:)];
    screenEdgePanGesture.edges = UIRectEdgeRight;
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showToolBar:)];

    [self.tabBarController.view addGestureRecognizer:screenEdgePanGesture];
    [self.tabBarController.view addGestureRecognizer:longPressGesture];

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)showToolBar:(id)gesture {
    if(!showToolBar){
        self.tabBarController.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
    }else{
        self.tabBarController.navigationController.navigationBar.hidden = NO;
        self.tabBarController.tabBar.hidden = NO;
    }
    showToolBar=!showToolBar;
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

#pragma mark UITabbarControllerDelegate Implements

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

    //给TabBar设置过渡动画
    //set up crossfade transition
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    //apply transition to tab bar controller's view
    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
}

#pragma mark UITableViewDataSource Implements

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (self.tabBarController.selectedIndex){
        case 2:{
            return 6;
        }
        case 1:{
            return 13;
        }
        default:{
            return 18;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    switch (self.tabBarController.selectedIndex){
        //性能相关
        case 2:{
            switch (indexPath.row){
                case 0:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([OptimizeViewController class])];
                    break;
                }
                case 1:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([ImageIOViewController class])];
                    break;
                }
                case 2:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([CollectionScrollViewController class])];
                    break;
                }
                case 3:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([CollectionTiledLayerViewController class])];
                    break;
                }
                case 4:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([PVRImageViewController class])];
                    break;
                }
                case 5:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([Matrix3DViewController class])];
                    break;
                }
                default:
                    break;
            }
            break;
        }

        //动画相关
        case 1:{
            switch (indexPath.row){
                case 0:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([KeyFrameAnimationViewController class])];
                    break;
                }
                case 1:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([ImplicitAnimationViewController class])];
                    break;
                }
                case 2:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([PresentationViewController class])];
                    break;
                }
                case 3:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([BasicAnimationViewController class])];
                    break;
                }
                case 4:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([BezierAnimationViewController class])];
                    break;
                }
                case 5:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([TransitionViewController class])];
                    break;
                }
                case 6:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([StopAnimationViewController class])];
                    break;
                }
                case 7:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([MediaTimingViewController class])];
                    break;
                }
                case 8:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([OpenDoorViewController class])];
                    break;
                }
                case 9:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([RelativeTimeViewController class])];
                    break;
                }
                case 10:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([OpenDoorViewController class])];
                    break;
                }
                case 11:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([MediaTimingFunctionViewController class])];
                    break;
                }
                case 12:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([ReboundBallViewController class])];
                    break;
                }
                case 13:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([ChipmunkViewController class])];
                    break;
                }
                default:
                    break;
            }
            break;
        }

        //图层相关
        default:{
            switch (indexPath.row){
                case 0:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([ViewController class])];
                    break;
                }
                case 1:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([ContentRectViewController class])];
                    break;
                }
                case 2:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([ClickViewController class])];
                    break;
                }
                case 3:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([HitTestViewController class])];
                    break;
                }
                case 4:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([ShadowViewController class])];
                    break;
                }
                case 5:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([MaskViewController class])];
                    break;
                }
                case 6:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([NearestViewController class])];
                    break;
                }
                case 7:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([GroupOpacityViewController class])];
                    break;
                }
                case 8:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([TransformViewController class])];
                    break;
                }
                case 9:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([Transform3dViewController class])];
                    break;
                }
                case 10:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([Cube3dViewController class])];
                    break;
                }
                case 11:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([GradientLayerViewController class])];
                    break;
                }
                case 12:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([ReplicatorLayerViewController class])];
                    break;
                }
                case 13:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([ShapeLayerViewController class])];
                    break;
                }
                case 14:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([TextLayerViewController class])];
                    break;
                }
                case 15:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([TiledLayerViewController class])];
                    break;
                }
                case 16:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([TransformLayerViewController class])];
                    break;
                }
                case 17:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([EmitterLayerViewController class])];
                    break;
                }
                case 18:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([EAGLLayerViewController class])];
                    break;
                }
                case 19:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([PlayerLayerViewController class])];
                    break;
                }
                case 20:{
                    cell.textLabel.text = [NSString stringWithUTF8String:class_getName([DrawViewController class])];
                    break;
                }
                default:
                    break;
            }
            break;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    switch (self.tabBarController.selectedIndex){
        //性能相关
        case 2:{
            switch (indexPath.row){
                case 0:{
                    OptimizeViewController *viewController = [OptimizeViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([OptimizeViewController class])];
                    [self.navViewController3 pushViewController:viewController animated:YES];
                    break;
                }
                case 1:{
                    ImageIOViewController *viewController = [ImageIOViewController new];
                    viewController.title  = [NSString stringWithUTF8String:class_getName([ImageIOViewController class])];
                    [self.navViewController3 pushViewController:viewController animated:YES];
                    break;
                }
                case 2:{
                    CollectionScrollViewController *viewController = [CollectionScrollViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([CollectionScrollViewController class])];
                    [self.navViewController3 pushViewController:viewController animated:YES];
                    break;
                }
                case 3:{
                    CollectionTiledLayerViewController *viewController = [CollectionTiledLayerViewController new];
                    viewController.title  = [NSString stringWithUTF8String:class_getName([CollectionTiledLayerViewController class])];
                    [self.navViewController3 pushViewController:viewController animated:YES];
                    break;
                }
                case 4:{
                    PVRImageViewController *viewController = [PVRImageViewController new];
                    viewController.title  = [NSString stringWithUTF8String:class_getName([PVRImageViewController class])];
                    [self.navViewController3 pushViewController:viewController animated:YES];
                    break;
                }
                case 5:{
                    Matrix3DViewController *viewController = [Matrix3DViewController new];
                    viewController.title  = [NSString stringWithUTF8String:class_getName([Matrix3DViewController class])];
                    [self.navViewController3 pushViewController:viewController animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }

            //动画相关
        case 1:{
            switch (indexPath.row){
                case 0:{
                    KeyFrameAnimationViewController *viewController = [KeyFrameAnimationViewController new];
                    viewController.title  = [NSString stringWithUTF8String:class_getName([KeyFrameAnimationViewController class])];
                    [self.navViewController2 pushViewController:viewController animated:YES];
                    break;
                }
                case 1:{
                    ImplicitAnimationViewController *viewController = [ImplicitAnimationViewController new];
                    viewController.title  = [NSString stringWithUTF8String:class_getName([ImplicitAnimationViewController class])];
                    [self.navViewController2 pushViewController:viewController animated:YES];
                    break;
                }
                case 2:{
                    PresentationViewController *viewController = [PresentationViewController new];
                    viewController.title  = [NSString stringWithUTF8String:class_getName([PresentationViewController class])];
                    [self.navViewController2 pushViewController:viewController animated:YES];
                    break;
                }
                case 3:{
                    BasicAnimationViewController *viewController = [BasicAnimationViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([BasicAnimationViewController class])];
                    [self.navViewController2 pushViewController:viewController animated:YES];
                    break;
                }
                case 4:{
                    BezierAnimationViewController *viewController = [BezierAnimationViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([BezierAnimationViewController class])];
                    [self.navViewController2 pushViewController:viewController animated:YES];
                    break;
                }
                case 5:{
                    TransitionViewController *viewController = [TransitionViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([TransitionViewController class])];
                    [self.navViewController2 pushViewController:viewController animated:YES];
                    break;
                }
                case 6:{
                    StopAnimationViewController *viewController = [StopAnimationViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([StopAnimationViewController class])];
                    [self.navViewController2 pushViewController:viewController animated:YES];
                    break;
                }
                case 7:{
                    MediaTimingViewController *viewController = [MediaTimingViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([MediaTimingViewController class])];
                    [self.navViewController2 pushViewController:viewController animated:YES];
                    break;
                }
                case 8:{
                    OpenDoorViewController *viewController = [OpenDoorViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([OpenDoorViewController class])];
                    [self.navViewController2 pushViewController:viewController animated:YES];
                    break;
                }
                case 9:{
                    RelativeTimeViewController *viewController = [RelativeTimeViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([RelativeTimeViewController class])];
                    [self.navViewController2 pushViewController:viewController animated:YES];
                    break;
                }
                case 10:{
                    OpenDoorViewController *viewController = [OpenDoorViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([OpenDoorViewController class])];
                    [self.navViewController2 pushViewController:viewController animated:YES];
                    break;
                }
                case 11:{
                    MediaTimingFunctionViewController *viewController = [MediaTimingFunctionViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([MediaTimingFunctionViewController class])];
                    [self.navViewController2 pushViewController:viewController animated:YES];
                    break;
                }
                case 12:{
                    ReboundBallViewController *viewController = [ReboundBallViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([ReboundBallViewController class])];
                    [self.navViewController2 pushViewController:viewController animated:YES];
                    break;
                }
                case 13:{
                    ChipmunkViewController *viewController = [ChipmunkViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([ChipmunkViewController class])];
                    [self.navViewController2 pushViewController:viewController animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }

            //图层相关
        default:{
            switch (indexPath.row){
                case 0:{
                    ViewController *viewController = [ViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([ViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 1:{
                    ContentRectViewController *viewController = [ContentRectViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([ContentRectViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 2:{
                    ClickViewController *viewController = [ClickViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([ClickViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 3:{
                    HitTestViewController *viewController = [HitTestViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([HitTestViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 4:{
                    ShadowViewController *viewController = [ShadowViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([ShadowViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 5:{
                    MaskViewController *viewController = [MaskViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([MaskViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 6:{
                    NearestViewController *viewController = [NearestViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([NearestViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 7:{
                    GroupOpacityViewController *viewController = [GroupOpacityViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([GroupOpacityViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 8:{
                    TransformViewController *viewController = [TransformViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([TransformViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 9:{
                    Transform3dViewController *viewController = [Transform3dViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([Transform3dViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 10:{
                    Cube3dViewController *viewController = [Cube3dViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([Cube3dViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 11:{
                    GradientLayerViewController *viewController = [GradientLayerViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([GradientLayerViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 12:{
                    ReplicatorLayerViewController *viewController = [ReplicatorLayerViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([ReplicatorLayerViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 13:{
                    ShapeLayerViewController *viewController = [ShapeLayerViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([ShapeLayerViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 14:{
                    TextLayerViewController *viewController = [TextLayerViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([TextLayerViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 15:{
                    TiledLayerViewController *viewController = [TiledLayerViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([TiledLayerViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 16:{
                    TransformLayerViewController *viewController = [TransformLayerViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([TransformLayerViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 17:{
                    EmitterLayerViewController *viewController = [EmitterLayerViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([EmitterLayerViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 18:{
                    EAGLLayerViewController *viewController = [EAGLLayerViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([EAGLLayerViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 19:{
                    PlayerLayerViewController *viewController = [PlayerLayerViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([PlayerLayerViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                case 20:{
                    DrawViewController *viewController = [DrawViewController new];
                    viewController.title = [NSString stringWithUTF8String:class_getName([DrawViewController class])];
                    [self.navViewController1 pushViewController:viewController animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
