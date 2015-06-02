//
//  RelativeTimeViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/14.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "RelativeTimeViewController.h"

@interface RelativeTimeViewController ()
@property(nonatomic, weak) IBOutlet UIView *containerView;
@property(nonatomic, weak) IBOutlet UILabel *speedLabel;
@property(nonatomic, weak) IBOutlet UILabel *timeOffsetLabel;
@property(nonatomic, weak) IBOutlet UISlider *speedSlider;
@property(nonatomic, weak) IBOutlet UISlider *timeOffsetSlider;
@property(nonatomic, strong) UIBezierPath *bezierPath;
@property(nonatomic, strong) CALayer *shipLayer;
//@property(nonatomic) CGAffineTransform transform;
@end

@implementation RelativeTimeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //create a path
    self.bezierPath = [[UIBezierPath alloc] init];
    [self.bezierPath moveToPoint:CGPointMake(160, 400)];
    [self.bezierPath addCurveToPoint:CGPointMake(160, 40)
                       controlPoint1:CGPointMake(80, 200)
                       controlPoint2:CGPointMake(240, 240)];
    //draw the path using a CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = self.bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.containerView.layer addSublayer:pathLayer];
    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 64, 64);
    self.shipLayer.position = CGPointMake(160, 400);
    self.shipLayer.contents = (__bridge id) [UIImage imageNamed:@"Ship1.png"].CGImage;
    [self.containerView.layer addSublayer:self.shipLayer];
    //set initial values
    [self updateSliders];
}

- (IBAction)updateSliders {
    CFTimeInterval timeOffset = self.timeOffsetSlider.value;
    self.timeOffsetLabel.text = [NSString stringWithFormat:@"%0.2f", timeOffset];
    float speed = self.speedSlider.value;
    self.speedLabel.text = [NSString stringWithFormat:@"%0.2f", speed];
}

- (IBAction)play {
    [self.shipLayer setAffineTransform:CGAffineTransformRotate(self.shipLayer.affineTransform,90.0*M_PI/180)];

    //create the keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.timeOffset = self.timeOffsetSlider.value;
    animation.speed = self.speedSlider.value;
    animation.duration = 1.0;
    animation.path = self.bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    animation.removedOnCompletion = NO;

    //要使animationDidStop: finished生效,要加上这句
    animation.delegate = self;
    [self.shipLayer addAnimation:animation forKey:@"slide"];

}

- (void)animationDidStart:(CAAnimation *)anim {
//    [self.shipLayer setAffineTransform:CGAffineTransformRotate(self.shipLayer.affineTransform, 90.0 * M_PI / 180)];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //重载这个方法，要注释父类的调用
//    [super animationDidStop:anim finished:flag];

//    CALayer *presentationLayer = self.shipLayer.presentationLayer;
//    self.shipLayer.affineTransform = presentationLayer.affineTransform;

    [self.shipLayer removeAnimationForKey:@"slide"];
    self.shipLayer.affineTransform = CGAffineTransformIdentity;
//    [self.shipLayer setAffineTransform:CGAffineTransformRotate(self.shipLayer.affineTransform,-90.0*M_PI/180)];
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
