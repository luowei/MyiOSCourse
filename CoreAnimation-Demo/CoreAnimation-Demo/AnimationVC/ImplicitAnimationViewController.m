//
//  ImplicitAnimationViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/12.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "ImplicitAnimationViewController.h"

@interface ImplicitAnimationViewController ()

@property(weak, nonatomic) IBOutlet UIView *layerView;
@property(weak, nonatomic) IBOutlet UIButton *changeBtn;

@property(strong, nonatomic) CALayer *colorLayer;

@end

@implementation ImplicitAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.//设置按钮边框颜色
    _changeBtn.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:1 alpha:1].CGColor;
    _layerView.layer.cornerRadius = 10.0f;
    _layerView.layer.masksToBounds = YES;
    
    //create sublayer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.cornerRadius = 10.0f;
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;

    //行为通常是一个被Core Animation隐式调用的显式动画对象。
    //这里我们使用的是一个实现了CATransaction的实例，叫做推进过渡。
    //add a custom action
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    self.colorLayer.actions = @{@"backgroundColor": transition};
    

    //add it to our view
    [self.layerView.layer addSublayer:self.colorLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeColor {

    //begin a new transaction
    [CATransaction begin];
    //set the animation duration to 1 second
    [CATransaction setAnimationDuration:0.5];
    //add the spin animation on completion
    [CATransaction setCompletionBlock:^{
        //rotate the layer 90 degrees
        CGAffineTransform transform = self.colorLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        self.colorLayer.affineTransform = transform;

//        //旋转与变色同步进行
//        //randomize the layer background color
//        CGFloat red = arc4random() / (CGFloat)INT_MAX;
//        CGFloat green = arc4random() / (CGFloat)INT_MAX;
//        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    }];
    //旋转与变色异步进行，先变色，再执行block中的旋转动画
    //randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;

    //commit the transaction
    [CATransaction commit];
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
