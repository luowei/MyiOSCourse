//
//  ViewController.m
//  HelloWorld
//
//  Created by luowei on 15/3/4.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "ViewController.h"
//#import "FrameWorkTest/CircleView.h"
#import "EllipseView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIImage *image = [UIImage imageNamed:@"me.jpeg"];
    EllipseView *circleView = [[EllipseView alloc] initWithImage:image];
    [self.view addSubview:circleView];

    circleView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *dict = @{@"circleView":circleView};

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:circleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[circleView(width)]"
                                                                      options:0 metrics:@{@"width":@(200)} views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[circleView(height)]"
                                                                      options:0 metrics:@{@"height":@(200)} views:dict]];
    [self.view updateConstraints];

    circleView.image = [circleView getEllipseImageFrom:image boardWidth:16.0 boardColor:[UIColor orangeColor]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClick:(UIButton *)sender {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title AA" message:@"bbbbbbbbb" delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
