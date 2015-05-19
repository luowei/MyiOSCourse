//
// Created by luowei on 15/5/18.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "CustomeKeyboardViewController.h"


@implementation CustomeKeyboardViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textViews = @[].mutableCopy;

    UIToolbar *toolBar = [self createToolbar];
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UITextView class]]) {
            [self.textViews addObject:v];

            [v performSelector:@selector(setDelegate:) withObject:self];
            [v performSelector:@selector(setInputAccessoryView:) withObject:toolBar];
        }
    }

}


@end