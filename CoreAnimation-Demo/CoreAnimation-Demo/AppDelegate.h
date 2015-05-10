//
//  AppDelegate.h
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/11.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define StatusBarHeight (IOS7==YES ? 0 : 20)
#define BackHeight      (IOS7==YES ? 0 : 15)

#define fNavBarHeigth (IOS7==YES ? 64 : 44)

#define fDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define fDeviceHeight ([UIScreen mainScreen].bounds.size.height-StatusBarHeight)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) UINavigationController *navViewController1;
@property(nonatomic, strong) UINavigationController *navViewController2;
@property(nonatomic, strong) UINavigationController *navViewController3;
@end

