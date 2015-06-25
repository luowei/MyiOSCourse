//
//  BSViewController.h
//  Webkit-Demo
//
//  Created by luowei on 15/4/29.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class BSListWebViewController;
@class MyWebView;

@interface BSViewController : UIViewController

@property(nonatomic, strong) BSListWebViewController *listWebViewController;

@property (nonatomic,strong) MyWebView *activeWindow;


@end
