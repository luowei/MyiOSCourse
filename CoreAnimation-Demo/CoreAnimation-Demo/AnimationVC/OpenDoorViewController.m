//
//  OpenDoorViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/14.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "OpenDoorViewController.h"

@interface OpenDoorViewController ()
@property (nonatomic, strong) UIView *containerView;
@end

@implementation OpenDoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 300, 400)];
    _containerView.backgroundColor = [UIColor lightGrayColor];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_containerView];


    //add the door
    CALayer *doorLayer = [CALayer layer];
    doorLayer.frame = CGRectMake(0, 0, 128, 256);
    doorLayer.position = CGPointMake(150 - 64, 150);
    doorLayer.anchorPoint = CGPointMake(0, 0.5);
    doorLayer.contents = (__bridge id)[UIImage imageNamed: @"meng"].CGImage;
    [self.containerView.layer addSublayer:doorLayer];
    //apply perspective transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    self.containerView.layer.sublayerTransform = perspective;
    //apply swinging animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 2.0;
    animation.repeatDuration = INFINITY;
    animation.autoreverses = YES;
    [doorLayer addAnimation:animation forKey:nil];
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
