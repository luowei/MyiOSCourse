//
//  BSListWebViewController.h
//  Webkit-Demo
//
//  Created by luowei on 15/6/24.
//  Copyright (c) 2015 rootls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSListWebViewController : UIViewController

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, copy) void (^updateDatasourceBlock)(WKWebView *);

- (instancetype)initWithWebView:(WKWebView *)webView;

@end
