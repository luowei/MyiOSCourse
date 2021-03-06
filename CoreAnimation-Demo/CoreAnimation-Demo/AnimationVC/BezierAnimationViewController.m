//
//  BezierAnimationViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/12.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "BezierAnimationViewController.h"

@interface BezierAnimationViewController ()
@property(nonatomic, weak) IBOutlet UIView *containerView;
@end

@implementation BezierAnimationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


/*

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //create a path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(150, 350)];
    [bezierPath addCurveToPoint:CGPointMake(150, 50) controlPoint1:CGPointMake(0, 125) controlPoint2:CGPointMake(300, 275)];
    //draw the path using a CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:pathLayer];
    //add the ship
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 64, 64);
    shipLayer.position = CGPointMake(150, 350);
    shipLayer.contents = (__bridge id)[UIImage imageNamed: @"ship"].CGImage;
    [self.view.layer addSublayer:shipLayer];

    //使用KeyFrame做动画
    //create the keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 4.0;
    animation.path = bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    [shipLayer addAnimation:animation forKey:nil];

//    对transform.rotation关键路径应用动画
//    //animate the ship rotation
//    CABasicAnimation *animation2 = [CABasicAnimation animation];
//    animation2.keyPath = @"transform.rotation";
//    animation2.duration = 2.0;
//    animation2.byValue = @(M_PI * 2);
//    [shipLayer addAnimation:animation2 forKey:nil];
}

*/

- (void)viewDidLoad {
    [super viewDidLoad];

    //create a path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(150, 350)];
    [bezierPath addCurveToPoint:CGPointMake(150, 50) controlPoint1:CGPointMake(0, 125) controlPoint2:CGPointMake(300, 275)];
    //draw the path using a CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.containerView.layer addSublayer:pathLayer];
    //add a colored layer
    CALayer *colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(0, 0, 64, 64);
    colorLayer.position = CGPointMake(150, 350);
    colorLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.containerView.layer addSublayer:colorLayer];
    //create the position animation
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
    animation1.keyPath = @"position";
    animation1.path = bezierPath.CGPath;
    animation1.rotationMode = kCAAnimationRotateAuto;
    //create the color animation
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"backgroundColor";
    animation2.toValue = (__bridge id) [UIColor redColor].CGColor;
    //create group animation
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[animation1, animation2];
    groupAnimation.duration = 4.0;
    //add the animation to the color layer
    [colorLayer addAnimation:groupAnimation forKey:nil];
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
