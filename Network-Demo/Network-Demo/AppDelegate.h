//
//  AppDelegate.h
//  CFNetWork-Demo
//
//  Created by luowei on 15/5/7.
//
//

#import <UIKit/UIKit.h>
//#import <objc/objc.h>
#import <objc/runtime.h>

#define BLog(formatString, ...) NSLog((@"%s " formatString), __PRETTY_FUNCTION__, ##__VA_ARGS__);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy) void (^backgroundSessionCompletionHandler)();


@end

