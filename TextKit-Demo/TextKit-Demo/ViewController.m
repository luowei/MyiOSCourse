//
//  ViewController.m
//  TextKit-Demo
//
//  Created by luowei on 15/5/4.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    NSTextStorage *textStorage = [NSTextStorage new];

    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [textStorage addLayoutManager: layoutManager];

    NSTextContainer *textContainer = [NSTextContainer new];
    [layoutManager addTextContainer: textContainer];

    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)
                                               textContainer:textContainer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
