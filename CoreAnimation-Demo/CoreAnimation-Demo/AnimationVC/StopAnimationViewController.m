//
//  StopAnimationViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/13.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "StopAnimationViewController.h"

@interface StopAnimationViewController ()
@property(nonatomic, weak) IBOutlet UIView *containerView;
@property(nonatomic, strong) CALayer *shipLayer;
@end

@implementation StopAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
//    self.tabBarController.tabBar.hidden = YES;

    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 128, 128);
    self.shipLayer.position = CGPointMake(150, 150);
    self.shipLayer.contents = (__bridge id) [UIImage imageNamed:@"ship"].CGImage;
    [self.containerView.layer addSublayer:self.shipLayer];
}

- (IBAction)start {
    //animate the ship rotation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 2.0;
    animation.byValue = @(M_PI * 2);
    animation.delegate = self;
    [self.shipLayer addAnimation:animation forKey:@"rotateAnimation"];
}

- (IBAction)stop {
    [self.shipLayer removeAnimationForKey:@"rotateAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //log that the animation stopped
    NSLog(@"The animation stopped (finished: %@)", flag ? @"YES" : @"NO");
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
