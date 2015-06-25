//
//  MyWebView.h
//  Webkit-Demo
//
//  Created by luowei on 15/6/25.
//  Copyright (c) 2015 rootls. All rights reserved.
//



#import <WebKit/WebKit.h>

@interface MyWebView : WKWebView<WKNavigationDelegate, WKScriptMessageHandler>

@property(nonatomic, copy) void (^finishNavigationProgressBlock)();
@end
