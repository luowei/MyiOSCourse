//
//  TKDHighlightingViewController.m
//  TextKit-Demo
//
//  Created by luowei on 15/5/5.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import "TKDHighlightingViewController.h"

#import "TKDHighlightingTextStorage.h"

@interface TKDHighlightingViewController () {
    // Text storage 必须要强引用，只有 default storage is retained by the text view.
    TKDHighlightingTextStorage *_textStorage;
}

@property(strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) NSLayoutConstraint *textViewBottomConstraint;

@end

@implementation TKDHighlightingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.textView = [[UITextView alloc] initWithFrame:self.view.frame];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];

    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[textView]|"
                                                                      options:nil metrics:nil
                                                                        views:@{@"textView":self.textView}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0 constant:20]];
    self.textViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.textView
                                                    attribute:NSLayoutAttributeBottom
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:self.view
                                                    attribute:NSLayoutAttributeBottom
                                                   multiplier:1.0 constant:0];
    [self.view addConstraint:self.textViewBottomConstraint];

    // Replace text storage
    _textStorage = [TKDHighlightingTextStorage new];
    [_textStorage addLayoutManager:self.textView.layoutManager];

    // Load iText
    [_textStorage replaceCharactersInRange:NSMakeRange(0, 0)
                                withString:[NSString stringWithContentsOfURL:[NSBundle.mainBundle
                                        URLForResource:@"iText" withExtension:@"txt"] usedEncoding:NULL error:NULL]];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShowOrHide:)
                                               name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShowOrHide:)
                                               name:UIKeyboardDidHideNotification object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard status

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    CGFloat newInset;
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification])
        newInset = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    else
        newInset = 20;

//    [self.textViewBottomConstraint setConstant:newInset];
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
