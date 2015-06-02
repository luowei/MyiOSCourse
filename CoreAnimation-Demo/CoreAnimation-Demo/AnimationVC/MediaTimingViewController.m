//
//  MediaTimingViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/14.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "MediaTimingViewController.h"

@interface MediaTimingViewController ()
@property(nonatomic, weak) IBOutlet UIView *containerView;
@property(nonatomic, weak) IBOutlet UITextField *durationField;
@property(nonatomic, weak) IBOutlet UITextField *repeatField;
@property(nonatomic, weak) IBOutlet UIButton *startButton;
@property(nonatomic, strong) CALayer *shipLayer;
@end

@implementation MediaTimingViewController

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
////    self.edgesForExtendedLayout = UIRectEdgeBottom;

    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = self.containerView.bounds;
    self.shipLayer.contents = (__bridge id) [UIImage imageNamed:@"mm.jpg"].CGImage;
    [self.containerView.layer addSublayer:self.shipLayer];
}

- (void)setControlsEnabled:(BOOL)enabled {
    for (UIControl *control in @[self.durationField, self.repeatField, self.startButton]) {
        control.enabled = enabled;
        control.alpha = enabled ? 1.0f : 0.25f;
    }
}


- (IBAction)hideKeyboard {
    [self.durationField resignFirstResponder];
    [self.repeatField resignFirstResponder];
}

- (IBAction)start {
    CFTimeInterval duration = [self.durationField.text doubleValue];
    float repeatCount = [self.repeatField.text floatValue];
    //animate the ship rotation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.byValue = @(M_PI * 2);
    animation.delegate = self;
    [self.shipLayer addAnimation:animation forKey:@"rotateAnimation"];
    //disable controls
    [self setControlsEnabled:NO];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //reenable controls
    [self setControlsEnabled:YES];
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
