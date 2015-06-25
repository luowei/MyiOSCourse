//
//  BSViewController.m
//  Webkit-Demo
//
//  Created by luowei on 15/4/29.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import "BSViewController.h"
#import "BSListWebViewController.h"
#import "MyWebView.h"
#import "AppDelegate.h"


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

@interface BSViewController () <UITextFieldDelegate, UISearchBarDelegate>

@property(nonatomic, strong) UIView *barView;

//@property(nonatomic, strong) UITextField *urlField;
@property(strong, nonatomic) UISearchBar *searchBar;
@property(nonatomic, strong) UIToolbar *bottomToolbar;
@property(nonatomic, strong) UIBarButtonItem *backBtn;
@property(nonatomic, strong) UIBarButtonItem *forwardBtn;
@property(nonatomic, strong) UIBarButtonItem *reloadBtn;
@property(nonatomic, strong) UIProgressView *progressView;

@property(nonatomic, strong) UIButton *addWebViewBtn;
@property(nonatomic, strong) UIBarButtonItem *homeBtn;
@property(nonatomic, strong) UIBarButtonItem *favoriteBtn;
@property(nonatomic, strong) UIBarButtonItem *menuBtn;

@property(nonatomic, strong) UIView *webContainer;
@end

@implementation BSViewController

- (void)loadView {
    [super loadView];

    //进度条
    [self addProgressBar];

    //顶部地址搜索栏
    [self addTopBar];

    //底部工具栏
    [self addBottomBar];

    //添加webContainer
    [self addWebContainer];

    //向webContainer中添加webview
    [self addWebView:[[NSURL alloc] initWithString:@"http://www.baidu.com"]];

    //设置初始值
    self.backBtn.enabled = NO;
    self.forwardBtn.enabled = NO;

    //添加对webView的监听器
    [self.activeWindow addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.activeWindow addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.activeWindow addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

//进度条
- (void)addProgressBar {
    //进度条
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:self.progressView];
//    self.progressView.frame = CGRectMake(0, 0, self.view.frame.size.width, 3);

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
}

//地址栏
- (void)addTopBar {
    //地址栏
    self.barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.barView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:self.barView];

/*
    self.urlField = [[UITextField alloc] initWithFrame:CGRectMake(5, 7, self.view.frame.size.width - 40, 30)];
    [self.barView addSubview:self.urlField];
    self.urlField.backgroundColor = [UIColor whiteColor];
    self.urlField.layer.cornerRadius = 5;
    self.urlField.delegate = self;
    self.urlField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.urlField.keyboardType = UIKeyboardTypeURL;
    self.urlField.returnKeyType = UIReturnKeyGo;
    self.urlField.autocorrectionType = UITextAutocorrectionTypeNo;
*/

    _searchBar = [UISearchBar new];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索或输入地址";
//    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    _searchBar.autocorrectionType = UITextAutocorrectionTypeYes;
    self.navigationItem.titleView = _searchBar;

//    UIButton *btton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btton setFrame:CGRectMake(0, 0, 30, 30)];
//    [btton addTarget:self action:@selector(presentAddWebViewVC) forControlEvents:UIControlEventTouchUpInside];
//
//    UIImage *image = [UIImage imageNamed:@"mutiwindow"];
//    [btton setImage:image forState:UIControlStateNormal];
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btton];
////    barButton.action = @selector(presentAddWebViewVC);
////    barButton.target = self;
//    self.navigationItem.rightBarButtonItem = barButton;


//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"1" style:UIBarButtonItemStyleDone target:self action:@selector(presentAddWebViewVC)];


/*
    //新标签按钮
    self.addWebViewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.addWebViewBtn.frame = CGRectMake(self.view.frame.size.width - 35, 7, 30, 30);
    [self.addWebViewBtn setTitle:@"1" forState:UIControlStateNormal];
    self.addWebViewBtn.backgroundColor = [UIColor whiteColor];
    self.addWebViewBtn.layer.cornerRadius = 5;
    [self.addWebViewBtn addTarget:self action:@selector(presentAddWebViewVC) forControlEvents:UIControlEventTouchUpInside];
    [self.barView addSubview:self.addWebViewBtn];

    //导航条View
    self.barView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;

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
*/

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (!window.isKeyWindow) {
        [window makeKeyAndVisible];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

}

- (void)addBottomBar {
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
}

//webContainer作为webView的容器
- (void)addWebContainer {
    _webContainer = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:_webContainer belowSubview:_progressView];
    _webContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[webContainer]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"webContainer" : _webContainer}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[progressView]-0-[webContainer]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"webContainer" : _webContainer,
                                                                                @"progressView" : _progressView}]];
}

#pragma mark - Web View Creation

- (MyWebView *)addWebView:(NSURL *)url {
    //添加webview
    _activeWindow = [[MyWebView alloc] initWithFrame:_webContainer.frame configuration:[[WKWebViewConfiguration alloc] init]];
    _activeWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_webContainer addSubview:_activeWindow];
    [_webContainer bringSubviewToFront:_activeWindow];

    //加载页面
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_activeWindow loadRequest:request];

    //更新刷新进度条的block
    __weak __typeof(self) weakSelf = self;
    _activeWindow.finishNavigationProgressBlock = ^() {
        [weakSelf.progressView setProgress:0.0 animated:NO];
        weakSelf.progressView.trackTintColor = [UIColor whiteColor];
    };

    // Add to windows array and make active window
    if (!_listWebViewController) {
        _listWebViewController = [[BSListWebViewController alloc] initWithWebView:_activeWindow];

        //设置添加webView的block
        _listWebViewController.addWebViewBlock = ^(MyWebView **wb, NSURL *aurl) {
            *wb = [weakSelf addWebView:aurl];
        };
        //更新活跃webView的block
        _listWebViewController.updateActiveWindowBlock = ^(MyWebView *wb) {
            weakSelf.activeWindow = wb;
            [weakSelf.webContainer bringSubviewToFront:weakSelf.activeWindow];
        };

    } else {
        _listWebViewController.updateDatasourceBlock(_activeWindow);
    }

    return _activeWindow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //加上这句可以去掉毛玻璃效果
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationItem.hidesBackButton = YES;
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];

}

- (void)viewWillAppear:(BOOL)animated {

    [_activeWindow reload];
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

//添加新webView窗口
- (void)presentAddWebViewVC {
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_listWebViewController];
    [self presentViewController:_listWebViewController animated:YES completion:nil];
}

//主页
- (void)home {
    [self.activeWindow loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:@"http://www.baidu.com"]]];
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSString *text = textField.text;
    if ([text compare:@"http://" options:NSLiteralSearch range:NSMakeRange(0, 7)] != NSOrderedSame) {
        text = [NSString stringWithFormat:@"http://%@", text];
    }
    [_activeWindow loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:text]]];
    return NO;
}

//关闭一个webView
- (void)closeActiveWebView {
    //todo:
/*
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
*/
    
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
