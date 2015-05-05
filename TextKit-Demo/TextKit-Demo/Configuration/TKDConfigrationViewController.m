//
// Created by luowei on 15/5/5.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "TKDConfigrationViewController.h"


@interface TKDConfigrationViewController ()

@property(strong, nonatomic) UITextView *originalTextView;

@property(strong, nonatomic) UIView *otherContainerView;
@property(strong, nonatomic) UIView *thirdContainerView;

@end

@implementation TKDConfigrationViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupChildView];

    // Load text
    NSTextStorage *sharedTextStorage = self.originalTextView.textStorage;
    [sharedTextStorage replaceCharactersInRange:NSMakeRange(0, 0)
                                     withString:[NSString stringWithContentsOfURL:[NSBundle.mainBundle
                                                     URLForResource:@"lorem"
                                                      withExtension:@"txt"]
                                                                     usedEncoding:NULL error:NULL]];

    // Create a new text view on the original text storage
    NSLayoutManager *otherLayoutManager = [NSLayoutManager new];
    [sharedTextStorage addLayoutManager: otherLayoutManager];

    NSTextContainer *otherTextContainer = [[NSTextContainer alloc] initWithSize:self.otherContainerView.bounds.size];
    [otherLayoutManager addTextContainer: otherTextContainer];

    UITextView *otherTextView = [[UITextView alloc] initWithFrame:self.otherContainerView.bounds textContainer:otherTextContainer];
    otherTextView.backgroundColor = self.otherContainerView.backgroundColor;
    otherTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    otherTextView.scrollEnabled = NO;

    [self.otherContainerView addSubview:otherTextView];

    //create a second text view on the new layout manager text storage
    NSTextContainer *thirdTextContainer = [[NSTextContainer alloc] initWithSize:self.thirdContainerView.bounds.size];
    [otherLayoutManager addTextContainer:thirdTextContainer];

    UITextView *thirdTextView = [[UITextView alloc] initWithFrame:self.thirdContainerView.bounds textContainer:thirdTextContainer];
    thirdTextView.backgroundColor = self.thirdContainerView.backgroundColor;
    thirdTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.thirdContainerView addSubview:thirdTextView];

}

- (void)setupChildView {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(endEditing)];

    self.originalTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 2)];
    self.otherContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 2,
            self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    self.thirdContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2,
            self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    [self.view addSubview:self.originalTextView];
    [self.view addSubview:self.otherContainerView];
    [self.view addSubview:self.thirdContainerView];

    self.originalTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    self.originalTextView.backgroundColor = [UIColor whiteColor];
    self.otherContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.otherContainerView.backgroundColor = [UIColor lightGrayColor];
    self.thirdContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    self.thirdContainerView.backgroundColor = [UIColor grayColor];
}

- (void)endEditing {
    [self.view endEditing:YES];
}

@end