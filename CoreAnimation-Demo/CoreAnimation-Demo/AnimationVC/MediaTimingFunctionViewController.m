//
//  MediaTimingFunctionViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/15.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "MediaTimingFunctionViewController.h"

@interface MediaTimingFunctionViewController ()
@property(nonatomic, strong) CALayer *colorLayer;
@property (nonatomic, strong) IBOutlet UIView *layerView;
@end

@implementation MediaTimingFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;

    //create a red layer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];

    /*
    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.layerView.layer addSublayer:self.colorLayer];
    [self.view addSubview:_layerView];
    */
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    /*
    //缓冲函数的简单测试
    //configure the transaction
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    //set the position
    self.colorLayer.position = [[touches anyObject] locationInView:self.view];
    //commit transaction
    [CATransaction commit];
    */

    /*
    //使用UIKit动画的缓冲测试工程
    //perform the animation
    [UIView animateWithDuration:1.0 delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         //set the position
//                         self.layerView.center = [[touches anyObject] locationInView:self.view];
                         self.colorLayer.position = [[touches anyObject] locationInView:self.view];
                     }
                     completion:NULL];
    */

    //添加缓冲和关键帧动画
    //create a keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[
            (__bridge id)[UIColor blueColor].CGColor,
            (__bridge id)[UIColor redColor].CGColor,
            (__bridge id)[UIColor greenColor].CGColor,
            (__bridge id)[UIColor blueColor].CGColor ];
    //add timing function
    CAMediaTimingFunction *fn = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    animation.timingFunctions = @[fn, fn, fn];
    //apply animation to layer
    [self.colorLayer addAnimation:animation forKey:nil];


    //使用UIBezierPath绘制CAMediaTimingFunction
    //create timing function
//    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
//    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
//    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionDefault];
    //get control points
    CGPoint controlPoint1, controlPoint2;
    [function getControlPointAtIndex:1 values:(float *)&controlPoint1];
    [function getControlPointAtIndex:2 values:(float *)&controlPoint2];
    //create curve
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointZero];
    [path addCurveToPoint:CGPointMake(1, 1)
            controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    //scale the path up to a reasonable size for display
    [path applyTransform:CGAffineTransformMakeScale(200, 200)];
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 4.0f;
    shapeLayer.path = path.CGPath;
    [self.layerView.layer addSublayer:shapeLayer];
    //flip geometry so that 0,0 is in the bottom-left
    self.layerView.layer.geometryFlipped = YES;


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
