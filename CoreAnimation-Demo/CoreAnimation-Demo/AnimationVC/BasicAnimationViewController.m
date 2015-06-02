//
//  BasicAnimationViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/12.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "BasicAnimationViewController.h"

@interface BasicAnimationViewController ()
@property(nonatomic, weak) IBOutlet UIView *layerView;
@property(weak, nonatomic) IBOutlet UIButton *changeBtn;
@property(nonatomic, strong) CALayer *colorLayer;
@end

@implementation BasicAnimationViewController

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
    _changeBtn.layer.cornerRadius = 5.0f;
    _changeBtn.layer.borderWidth = 1.0f;
    _changeBtn.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:1 alpha:1].CGColor;
    _layerView.layer.cornerRadius = 10.0f;
    _layerView.layer.masksToBounds = YES;

    //create sublayer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    [self.layerView.layer addSublayer:self.colorLayer];
}

- (void)applyBasicAnimation:(CABasicAnimation *)animation toLayer:(CALayer *)layer {
    //set the from value (using presentation layer if available)
    animation.fromValue = [layer.presentationLayer ?: layer valueForKeyPath:animation.keyPath];
    //update the property in advance
    //note: this approach will only work if toValue != nil
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [layer setValue:animation.toValue forKeyPath:animation.keyPath];
    [CATransaction commit];
    //apply animation to layer
    [layer addAnimation:animation forKey:nil];
}

- (IBAction)changeColor {
    //create a new random color
    CGFloat red = arc4random() / (CGFloat) INT_MAX;
    CGFloat green = arc4random() / (CGFloat) INT_MAX;
    CGFloat blue = arc4random() / (CGFloat) INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //create a basic animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id) color.CGColor;
    //apply animation without snap-back
    [self applyBasicAnimation:animation toLayer:self.colorLayer];
}

*/

//--------  CAAnimationDelegate  ----------//
//用-animationDidStop:finished:方法在动画结束之后来更新图层的backgroundColor

- (void)viewDidLoad {
    [super viewDidLoad];

    //create sublayer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    [self.layerView.layer addSublayer:self.colorLayer];
}

- (IBAction)changeColor {
    //create a new random color
    CGFloat red = arc4random() / (CGFloat) INT_MAX;
    CGFloat green = arc4random() / (CGFloat) INT_MAX;
    CGFloat blue = arc4random() / (CGFloat) INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //create a basic animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id) color.CGColor;
    animation.delegate = self;
    //apply animation to layer
    [self.colorLayer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
    //set the backgroundColor property to match animation toValue
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.colorLayer.backgroundColor = (__bridge CGColorRef) anim.toValue;
    [CATransaction commit];
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
