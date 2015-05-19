//
// Created by luowei on 15/5/18.
// Copyright (c) 2015 rootls. All rights reserved.
//

#import "KeyBoardTypeViewController.h"


@interface KeyBoardTypeViewController()<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic, strong) NSMutableArray *textViews;

@end

@implementation KeyBoardTypeViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.textViews = @[].mutableCopy;

    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [self.textViews addObject:v];
            [v performSelector:@selector(setDelegate:) withObject:self];
        }
    }

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //取得一个触摸对象（对于多点触摸可能有多个对象）
    UITouch *touch=[touches anyObject];
    //取得当前位置
    CGPoint point=[touch locationInView:self.view];
    for(UIView *v in self.textViews){
        if(!CGRectContainsPoint(v.frame, point)){
            [v resignFirstResponder];
        }
    }
}

@end