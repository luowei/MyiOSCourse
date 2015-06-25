//
//  BSListWebViewController.h
//  Webkit-Demo
//
//  Created by luowei on 15/6/24.
//  Copyright (c) 2015 rootls. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyWebView;

@interface BSListWebViewController : UIViewController

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, copy) void (^updateDatasourceBlock)(MyWebView *);

@property(nonatomic, copy) void (^addWebViewBlock)(MyWebView **,NSURL *url);

@property(nonatomic, copy) void (^updateActiveWindowBlock)(MyWebView *);

- (instancetype)initWithWebView:(MyWebView *)webView;

@end
