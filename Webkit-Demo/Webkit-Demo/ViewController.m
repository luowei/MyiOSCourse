//
//  ViewController.m
//  Webkit-Demo
//
//  Created by luowei on 15/4/28.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>
@property(weak, nonatomic) IBOutlet UIWebView *webView;
@property(weak, nonatomic) IBOutlet UISegmentedControl *themeChooser;
@property(weak, nonatomic) IBOutlet UITextField *titleText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _webView.delegate = self;

    // Load the HTML content.
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    NSString *htmlPath = [resourcesPath stringByAppendingString:@"/index.html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
//    NSString * urlString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //约定函数名与参数以 :// 分隔
    NSArray *urlComps = [[[request URL] absoluteString] componentsSeparatedByString:@"://"];

    if ([urlComps count] && [urlComps[0] isEqualToString:@"showmessage"]) {
        NSArray *arrFucnameAndParameter = [urlComps[1] componentsSeparatedByString:@":/"];
        [self showMessage:arrFucnameAndParameter[0]];

    }
/*
    NSURL *url = request.URL;
    if ([[url scheme] isEqualToString:@"showmessage"]){
        [[[UIAlertView alloc] initWithTitle:@"来javascript的回调" message:@"bbbbbbbbbbbbbb"
                                   delegate:nil cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
*/

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *js = @"document.getElementById('contentTitle').innerText";
    _titleText.text = [webView stringByEvaluatingJavaScriptFromString:js];
}


- (IBAction)setContentTitle:(UIButton *)sender {
    NSString *js = [NSString stringWithFormat:@"document.getElementById('contentTitle').innerText = '%@'", _titleText.text];
    [_webView stringByEvaluatingJavaScriptFromString:js];
}

- (IBAction)addContent:(UIButton *)sender {
    NSString *js = [NSString stringWithFormat:@"\
            var contentNode = document.getElementById('main_content');\
            var contentEle = document.createElement('p');\
            contentEle.innerHTML = '%@';\
            contentNode.appendChild(contentEle);\
            ", @"aabbbccccdddddeeeeee"];
    [_webView stringByEvaluatingJavaScriptFromString:js];
}

- (IBAction)changeTheme:(UISegmentedControl *)segment {
    switch (segment.selectedSegmentIndex) {
        case 0:
            [_webView stringByEvaluatingJavaScriptFromString:
                    [NSString stringWithFormat:@"document.getElementById('ss').href = '%@'", @"Gray.css"]];
            break;
        case 1:
            [_webView stringByEvaluatingJavaScriptFromString:
                    [NSString stringWithFormat:@"document.getElementById('ss').href = '%@'", @"HUDdy.css"]];
            break;
        default:
            break;
    }
}

-(void)showMessage:(NSString *)msg{
    [[[UIAlertView alloc] initWithTitle:@"来javascript的回调" message:msg
                               delegate:nil cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}


@end
