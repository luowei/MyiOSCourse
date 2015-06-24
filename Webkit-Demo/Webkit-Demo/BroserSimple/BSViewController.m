//
//  BSViewController.m
//  Webkit-Demo
//
//  Created by luowei on 15/4/29.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import "BSViewController.h"
#import "BSListWebViewController.h"


@interface NSString (BSEncoding)

+ (NSString *)encodedString:(NSString *)string;

@end

@implementation NSString (BSEncoding)

+ (NSString *)encodedString:(NSString *)string {
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) string, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
}

@end

//
// This is our JS we're going to inject into each web view. It looks a bit messy,
// but in short, it overrides the window.open and window.close methods. It does
// this by creating an iframe and setting the iframe src attribute to a custom
// URL scheme: "hdwebview://".
//
// This custom URL scheme is followed by a method name we will catch in the
// webView:shouldStartLoadWithRequest:navigationType method. Our method names are:
//    - jswindowopenoverride
//    - jswindowcloseoverride
//
// There is also logic in this JS block that loops through all anchor tags on
// a given page, and finds any that have a target of "_blank", replacing the
// blank target with an onclick event that fires a window.open method, passing
// in the href attribute as the URL to open. And since we have overridden the
// window.open method, this action will be caught as a new window open event.
//
// At this time, I haven't yet figured out how to get window-to-window communication
// via JavaScript -- for example, having a child window call a method to its parent.
// If anyone can figure out how to do that, please let me know!
//

@interface BSViewController () <UITextFieldDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property(nonatomic, strong) UIView *barView;

@property(nonatomic, strong) UITextField *urlField;
@property(nonatomic, strong) UIToolbar *bottomToolbar;
@property(nonatomic, strong) UIBarButtonItem *backBtn;
@property(nonatomic, strong) UIBarButtonItem *forwardBtn;
@property(nonatomic, strong) UIBarButtonItem *reloadBtn;
@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property(nonatomic, strong) UIButton *addWebViewBtn;
@property(nonatomic, strong) UIBarButtonItem *homeBtn;
@property(nonatomic, strong) UIBarButtonItem *favoriteBtn;
@property(nonatomic, strong) UIBarButtonItem *menuBtn;

@end

@implementation BSViewController

- (void)loadView {
    [super loadView];

    //添加webview
    self.webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    [self newWebView];
    
    //进度条
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:self.progressView];
//    self.progressView.frame = CGRectMake(0, 0, self.view.frame.size.width, 3);
    [self.view insertSubview:self.activeWindow belowSubview:self.progressView];

    //地址栏
    self.barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.barView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:self.barView];

    self.urlField = [[UITextField alloc] initWithFrame:CGRectMake(5, 7, self.view.frame.size.width - 40, 30)];
    [self.barView addSubview:self.urlField];
    self.urlField.backgroundColor = [UIColor whiteColor];
    self.urlField.layer.cornerRadius = 5;
    self.urlField.delegate = self;
    self.urlField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.urlField.keyboardType = UIKeyboardTypeURL;
    self.urlField.returnKeyType = UIReturnKeyGo;
    self.urlField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //新标签按钮
    self.addWebViewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.addWebViewBtn.frame = CGRectMake(self.view.frame.size.width - 35, 7, 30, 30);
    [self.addWebViewBtn setTitle:@"1" forState:UIControlStateNormal];
    self.addWebViewBtn.backgroundColor = [UIColor whiteColor];
    self.addWebViewBtn.layer.cornerRadius = 5;
    [self.addWebViewBtn addTarget:self action:@selector(presentAddWebViewVC) forControlEvents:UIControlEventTouchUpInside];
    [self.barView addSubview:self.addWebViewBtn];

    //底部工具栏
    self.homeBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(home)];
    self.favoriteBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"favorite"] style:UIBarButtonItemStylePlain target:self action:@selector(favorite)];
    self.menuBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(menu)];
    self.reloadBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(reload:)];
    self.bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 120, self.view.frame.size.width, 40)];
    self.bottomToolbar.backgroundColor = [UIColor whiteColor];
    self.backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.forwardBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward"] style:UIBarButtonItemStylePlain target:self action:@selector(forward:)];

    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    fixedSpace.width = 20;


    self.bottomToolbar.items = @[self.homeBtn, fixedSpace, self.favoriteBtn, fixedSpace, self.menuBtn, fixedSpace, self.reloadBtn, flexibleSpace, self.backBtn, fixedSpace, self.forwardBtn];
    [self.view addSubview:self.bottomToolbar];
    [self.view bringSubviewToFront:self.bottomToolbar];

    self.backBtn.enabled = NO;
    self.forwardBtn.enabled = NO;
}

//添加新webView窗口
- (void)presentAddWebViewVC {

    if (_listWebViewController) {
        self.listWebViewController = [BSListWebViewController new];
    } else {
        [_listWebViewController updateDatasource:_windows];
    }

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_listWebViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}


#pragma mark - Web View Creation

- (WKWebView *)newWebView {
    //添加webview
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:self.webViewConfiguration];
    webView.navigationDelegate = self;
    webView.allowsBackForwardNavigationGestures = YES;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Add to windows array and make active window
    [self.windows addObject:webView];
    self.activeWindow = webView;
    
    return webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //加上这句可以去掉毛玻璃效果
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationItem.hidesBackButton = YES;
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];


    //添加对webView的监听器
    [self.activeWindow addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.activeWindow addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.activeWindow addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];

    [self addConstraints];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:@"http://www.baidu.com"]];
    [self.activeWindow loadRequest:request];

    //加载用户js文件,修改加载网页内容
    [self addUserScriptsToWeb];

}

- (void)dealloc {
    [self.activeWindow removeObserver:self forKeyPath:@"loading"];
    [self.activeWindow removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.activeWindow removeObserver:self forKeyPath:@"title"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        self.backBtn.enabled = self.activeWindow.canGoBack;
        self.forwardBtn.enabled = self.activeWindow.canGoForward;
    }
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.hidden = self.activeWindow.estimatedProgress == 1;
        [self.progressView setProgress:(float) self.activeWindow.estimatedProgress animated:YES];
    }
    if ([keyPath isEqualToString:@"title"]) {
        self.title = self.activeWindow.title;
    }
}

//主页
- (void)home {

}

//收藏
- (void)favorite {

}

//设置菜单
- (void)menu {

}

//刷新
- (void)reload:(UIBarButtonItem *)item {
    [self.activeWindow loadRequest:[NSURLRequest requestWithURL:self.activeWindow.URL]];
}

//返回
- (void)back:(UIBarButtonItem *)item {
    [self.activeWindow goBack];
}

//前进
- (void)forward:(UIBarButtonItem *)item {
    [self.activeWindow goForward];
}


- (void)addConstraints {
    //导航条View
    self.barView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;

    //progressView进度条
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[progressView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"progressView" : self.progressView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[progressView(2)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"progressView" : self.progressView}]];
    //textfield输入框
    self.urlField.translatesAutoresizingMaskIntoConstraints = NO;
    self.addWebViewBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.barView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[urlField]-5-[addWebViewBtn]-5-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"urlField" : self.urlField, @"addWebViewBtn" : self.addWebViewBtn}]];
    [self.barView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[urlField]-7-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"urlField" : self.urlField}]];
    [self.barView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[addWebViewBtn]-7-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"addWebViewBtn" : self.addWebViewBtn}]];

    //底部工具栏
    self.bottomToolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomToolbar]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"bottomToolbar" : self.bottomToolbar}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomToolbar(40)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"bottomToolbar" : self.bottomToolbar}]];
    //webView
    self.activeWindow.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[webView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"webView" : self.activeWindow}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[progressView]-0-[webView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"webView" : self.activeWindow,
                                                                                @"progressView" : self.progressView,
                                                                                @"bootomToolbar" : self.bottomToolbar}]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSString *text = textField.text;
    if ([text compare:@"http://" options:NSLiteralSearch range:NSMakeRange(0, 7)] != NSOrderedSame) {
        text = [NSString stringWithFormat:@"http://%@", text];
    }
    [_activeWindow loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:text]]];
    return NO;
}

//当加载页面发生错误
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//当页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.progressView setProgress:0.0 animated:NO];
    self.progressView.trackTintColor = [UIColor whiteColor];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    //处理特殊网址
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated && navigationAction.request.URL.host != nil
            && [navigationAction.request.URL.host.lowercaseString hasPrefix:@"www.youku.com"]) {
        //用用户默认浏览器safari打开
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }


/*
    if ([[[navigationAction.request URL] absoluteString] rangeOfString:@"affiliate_id="].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:[navigationAction.request URL]];
    }
    // Check URL for special prefix, which marks where we overrode JS. If caught, return NO.
    if ([[[navigationAction.request URL] absoluteString] hasPrefix:@"hdwebview"]) {

        // The injected JS window override separates the method (i.e. "jswindowopenoverride") and the
        // suffix (i.e. a URL to open in the overridden window.open method) with double pipes ("||")
        // Here we strip out the prefix and break apart the method so we know how to handle it.
        NSString *suffix = [[[navigationAction.request URL] absoluteString] stringByReplacingOccurrencesOfString:@"hdwebview://" withString:@""];
        NSArray *methodAsArray = [suffix componentsSeparatedByString:[NSString encodedString:@"||"]];
        NSString *method = methodAsArray[0];

        if ([method isEqualToString:@"jswindowopenoverride"]) {

            NSLog(@"window.open caught");
            WKWebView *wkwebView = [self newWebView];
            NSURL *url = [NSURL URLWithString:[NSString stringWithString:methodAsArray[1]]];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            [wkwebView loadRequest:requestObj];
            [self.view addSubview:wkwebView];
            NSLog(@"Number of windows: %d", [_windows count]);

        } else if ([method isEqualToString:@"jswindowcloseoverride"] || [method isEqualToString:@"jswindowopenerfocusoverride"]) {

            // Only close the active web view if it's not the base web view. We don't want to close
            // the last web view, only ones added to the top of the original one.
            NSLog(@"window.close caught");
            if ([self.windows count] > 1) {
                [self closeActiveWebView];
            }

        }

    }

    // If the web view isn't the active window, we don't want it to do any more requests.
    // This fixes the issue with popup window overrides, where the underlying window was still
    // trying to redirect to the original anchor tag location in addition to the new window
    // going to the same location, which resulted in the "back" button needing to be pressed twice.
    if (![webView isEqual:self.activeWindow]) {
    }
*/


}

//关闭一个webView
- (void)closeActiveWebView {
    // Grab and remove the top web view, remove its reference from the windows array,
    // and nil itself and its delegate. Then we re-set the activeWindow to the
    // now-top web view and refresh the toolbar.
    WKWebView *webView = [self.windows lastObject];
    [webView removeFromSuperview];
    [self.windows removeLastObject];
    webView.navigationDelegate = nil;
    webView = nil;
    NSLog(@"Number of windows: %d", [_windows count]);
    self.activeWindow = [self.windows lastObject];
}

//处理当接收到html页面脚本发来的消息
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//    [userContentController addScriptMessageHandler:self name:@"myName"];
    if ([message.name isEqualToString:@"myName"]) {
        //处理消息内容
//        [[[UIAlertView alloc] initWithTitle:@"message" message:message.body delegate:self
//                          cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}


//加载用户js文件
- (void)addUserScriptsToWeb {

    NSString *postingMsgScriptString = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"postingMsg" withExtension:@"js"]
                                                                encoding:NSUTF8StringEncoding error:NULL];
//    NSString *scriptString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"postingMsg" ofType:@"js"]
//                                                       encoding:NSUTF8StringEncoding error:NULL];

//    NSString *path = [[NSBundle mainBundle] pathsForResourcesOfType:@"js" inDirectory:@"Resource"][0];
//    NSString *scriptString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

//    //在document加载前执行注入js脚本
//    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:scriptString injectionTime:WKUserScriptInjectionTimeAtDocumentStart
//                                                   forMainFrameOnly:YES];

    //在document加载完成后执行注入js脚本
    WKUserScript *postingMsgScript = [[WKUserScript alloc] initWithSource:postingMsgScriptString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                   forMainFrameOnly:YES];
    [self.webViewConfiguration.userContentController addUserScript:postingMsgScript];

    //添加js脚本到处理器中
    [self.webViewConfiguration.userContentController addScriptMessageHandler:self name:@"myName"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
