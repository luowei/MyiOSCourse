//
//  AppDelegate.h
//  AVPlayer-Demo
//
//  Created by luowei on 15/5/10.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *cachedAssetBrowser;
@property (nonatomic, strong) ViewController* playbackViewController;

@end

