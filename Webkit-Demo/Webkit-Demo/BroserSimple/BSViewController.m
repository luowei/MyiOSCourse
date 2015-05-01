//
//  BSViewController.m
//  Webkit-Demo
//
//  Created by luowei on 15/4/29.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import "BSViewController.h"

@interface BSViewController () <UITextFieldDelegate,WKNavigationDelegate>

@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) UIView *barView;

@property(nonatomic, strong) UITextField *urlField;
@property(nonatomic, strong) UIToolbar *bottomToolbar;
@property(nonatomic, strong) UIBarButtonItem *backBtn;
@property(nonatomic, strong) UIBarButtonItem *forwardBtn;
@property(nonatomic, strong) UIBarButtonItem *reloadBtn;
@property(nonatomic, strong) UIProgressView *progressView;
@end

@implementation BSViewController

- (void)loadView {
    [super loadView];

    //添加webview
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
//    [self.view addSubview:self.webView];
    
    //进度条
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:self.progressView];
//    self.progressView.frame = CGRectMake(0, 0, self.view.frame.size.width, 3);
    [self.view insertSubview:self.webView belowSubview:self.progressView];

    //地址栏
    self.barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.barView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:self.barView];

    self.urlField = [[UITextField alloc] initWithFrame:CGRectMake(5, 7, self.view.frame.size.width - 10, 30)];
    [self.barView addSubview:self.urlField];
    self.urlField.backgroundColor = [UIColor whiteColor];
    self.urlField.layer.cornerRadius = 5;
    self.urlField.delegate = self;
    self.urlField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.urlField.keyboardType = UIKeyboardTypeURL;
    self.urlField.returnKeyType = UIReturnKeyGo;
    self.urlField.autocorrectionType = UITextAutocorrectionTypeNo;

    //底部工具栏
    self.bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-120, self.view.frame.size.width, 40)];
    self.bottomToolbar.backgroundColor = [UIColor whiteColor];
    self.backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.forwardBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward"] style:UIBarButtonItemStylePlain target:self action:@selector(forward:)];
    self.reloadBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(reload:)];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    fixedSpace.width = 20;


    self.bottomToolbar.items = @[self.backBtn,fixedSpace, self.forwardBtn,flexibleSpace, self.reloadBtn];
    [self.view addSubview:self.bottomToolbar];
    [self.view bringSubviewToFront:self.bottomToolbar];

    self.backBtn.enabled = NO;
    self.forwardBtn.enabled = NO;
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
    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    [self addConstraints];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:@"http://www.baidu.com"]];
    [self.webView loadRequest:request];

    
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"loading"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        self.backBtn.enabled = self.webView.canGoBack;
        self.forwardBtn.enabled = self.webView.canGoForward;
    }
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self. progressView.hidden = self.webView.estimatedProgress == 1;
        [self.progressView setProgress:(float) self.webView.estimatedProgress animated:YES];
    }
}

- (void)back:(UIBarButtonItem *)item {
    [self.webView goBack];
}

- (void)reload:(UIBarButtonItem *)item {
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.webView.URL]];
}

- (void)forward:(UIBarButtonItem *)item {
    [self.webView goForward];
}

- (void)addConstraints {
    //导航条View
    self.barView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;

    //progressView进度条
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[progressView]|"
                                                                      options:nil
                                                                      metrics:nil
                                                                        views:@{@"progressView" : self.progressView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[progressView(2)]"
                                                                      options:nil
                                                                      metrics:nil
                                                                        views:@{@"progressView" : self.progressView}]];
    //textfield输入框
    self.urlField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.barView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[urlField]-5-|"
                                                                         options:nil
                                                                         metrics:nil
                                                                           views:@{@"urlField" : self.urlField}]];
    [self.barView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[urlField]-7-|"
                                                                         options:nil
                                                                         metrics:nil
                                                                           views:@{@"urlField" : self.urlField}]];

    //底部工具栏
    self.bottomToolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomToolbar]|"
                                                                      options:nil
                                                                      metrics:nil
                                                                        views:@{@"bottomToolbar" : self.bottomToolbar}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomToolbar(40)]|"
                                                                      options:nil
                                                                      metrics:nil
                                                                        views:@{@"bottomToolbar" : self.bottomToolbar}]];
    //webView
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[webView]|"
                                                                      options:nil
                                                                      metrics:nil
                                                                        views:@{@"webView" : self.webView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[progressView]-0-[webView]|"
                                                                      options:nil
                                                                      metrics:nil
                                                                        views:@{@"webView" : self.webView,
                                                                                @"progressView":self.progressView,
                                                                                @"bootomToolbar":self.bottomToolbar}]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSString *text = textField.text;
    if ([text compare:@"http://" options:NSLiteralSearch range:NSMakeRange(0, 7)] != NSOrderedSame) {
        text = [NSString stringWithFormat:@"http://%@", text];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:text]]];
    return NO;
}

//当加载页面发生错误
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//当页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.progressView setProgress:0.0 animated:NO];
    self.progressView.trackTintColor = [UIColor whiteColor];
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
