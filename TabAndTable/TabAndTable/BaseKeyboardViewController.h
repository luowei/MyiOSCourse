//
// Created by luowei on 15/5/18.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseKeyboardViewController : UIViewController

- (UIToolbar *)createToolbar;
- (void)nextTextField;
- (void)prevTextField;
- (void)textFieldDone;


- (NSArray *)inputViews;

@end