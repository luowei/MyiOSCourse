//
//  ReboundBallViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/15.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "ReboundBallViewController.h"

@interface ReboundBallViewController ()
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UIImageView *ballView;

//@property(nonatomic, strong) NSTimer *timer;
//@property(nonatomic, assign) NSTimeInterval duration;
//@property(nonatomic, assign) NSTimeInterval timeOffset;
//@property(nonatomic, strong) id fromValue;
//@property(nonatomic, strong) id toValue;

@property(nonatomic, strong) CADisplayLink *timer;
@property(nonatomic, assign) CFTimeInterval duration;
@property(nonatomic, assign) CFTimeInterval timeOffset;
@property(nonatomic, assign) CFTimeInterval lastStep;
@property(nonatomic, strong) id fromValue;
@property(nonatomic, strong) id toValue;

@end

@implementation ReboundBallViewController

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

    _containerView = [[UIView alloc] initWithFrame:self.view.frame];
    _containerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_containerView];

    //add ball image view
    UIImage *ballImage = [UIImage imageNamed:@"Ball"];
    self.ballView = [[UIImageView alloc] initWithImage:ballImage];
    [self.view addSubview:self.ballView];
    //animate
    [self animate];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //replay animation on tap
    [self animate];
}

/*
//使用关键帧实现反弹球的动画
- (void)animate {
    //reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    //create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.delegate = self;
    animation.values = @[
            [NSValue valueWithCGPoint:CGPointMake(150, 32)],
            [NSValue valueWithCGPoint:CGPointMake(150, 268)],
            [NSValue valueWithCGPoint:CGPointMake(150, 140)],
            [NSValue valueWithCGPoint:CGPointMake(150, 268)],
            [NSValue valueWithCGPoint:CGPointMake(150, 220)],
            [NSValue valueWithCGPoint:CGPointMake(150, 268)],
            [NSValue valueWithCGPoint:CGPointMake(150, 250)],
            [NSValue valueWithCGPoint:CGPointMake(150, 268)]
    ];
    animation.timingFunctions = @[
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
    ];
    animation.keyTimes = @[@0.0, @0.3, @0.5, @0.7, @0.8, @0.9, @0.95, @1.0];
    //apply animation
    self.ballView.layer.position = CGPointMake(150, 268);
    [self.ballView.layer addAnimation:animation forKey:nil];
}
*/


/*
//使用插入的值创建一个关键帧动画
- (void)animate {
    //reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    //set up animation parameters
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    CFTimeInterval duration = 1.0;
    //generate keyframes
    NSInteger numFrames = duration * 60;
    NSMutableArray *frames = [NSMutableArray array];
    for (int i = 0; i < numFrames; i++) {
        float time = 1 / (float) numFrames * i;
        //apply easing
        time = bounceEaseOut(time);
        //add keyframe
        [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
    }
    //create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.delegate = self;
    animation.values = frames;
    //apply animation
    [self.ballView.layer addAnimation:animation forKey:nil];
}
*/

/*
//使用NSTimer实现弹性球动画
- (void)animate {
    //reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    //configure the animation
    self.duration = 1.0;
    self.timeOffset = 0.0;
    self.fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    self.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    //stop the timer if it's already running
    [self.timer invalidate];
    //start the timer
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 / 60.0
//                                                  target:self
//                                                selector:@selector(step:)
//                                                userInfo:nil
//                                                 repeats:YES];

//    NSTimer同样也可以使用不同的run loop模式配置
//    通过别的函数，而不是+scheduledTimerWithTimeInterval:构造器
    self.timer = [NSTimer timerWithTimeInterval:1/60.0
                                         target:self
                                       selector:@selector(step:)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer
                              forMode:NSRunLoopCommonModes];
}

- (void)step:(NSTimer *)step {
    //update time offset
    self.timeOffset = MIN(self.timeOffset + 1 / 60.0, self.duration);
    //get normalized time offset (in range 0 - 1)
    float time = self.timeOffset / self.duration;
    //apply easing
    time = bounceEaseOut(time);
    //interpolate position
    id position = [self interpolateFromValue:self.fromValue
                                     toValue:self.toValue
                                        time:time];
    //move ball view to new position
    self.ballView.center = [position CGPointValue];
    //stop the timer if we've reached the end of the animation
    if (self.timeOffset >= self.duration) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
*/


//通过测量没帧持续的时间来使得动画更加平滑

//CADisplayLink有一个整型的frameInterval属性，指定了间隔多少帧之后才执行。
//默认值是1，意味着每次屏幕更新之前都会执行一次。

- (void)animate {
    //reset ball to top of screen
    self.ballView.center = CGPointMake(150, 32);
    //configure the animation
    self.duration = 1.0;
    self.timeOffset = 0.0;
    self.fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    self.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    //stop the timer if it's already running
    [self.timer invalidate];
    //start the timer
    self.lastStep = CACurrentMediaTime();
    self.timer = [CADisplayLink displayLinkWithTarget:self
                                             selector:@selector(step:)];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop]
                     forMode:NSDefaultRunLoopMode];

//    对CADisplayLink指定多个run loop模式，于是我们可以同时加入NSDefaultRunLoopMode
// 和UITrackingRunLoopMode来保证它不会被滑动打断，也不会被其他UIKit控件动画影响性能
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
}

- (void)step:(CADisplayLink *)timer {
    //calculate time delta
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - self.lastStep;
    self.lastStep = thisStep;
    //update time offset
    self.timeOffset = MIN(self.timeOffset + stepDuration, self.duration);
    //get normalized time offset (in range 0 - 1)
    float time = self.timeOffset / self.duration;
    //apply easing
    time = bounceEaseOut(time);
    //interpolate position
    id position = [self interpolateFromValue:self.fromValue toValue:self.toValue
                                        time:time];
    //move ball view to new position
    self.ballView.center = [position CGPointValue];
    //stop the timer if we've reached the end of the animation
    if (self.timeOffset >= self.duration) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


float interpolate(float from, float to, float time) {
    return (to - from) * time + from;
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time {
    if ([fromValue isKindOfClass:[NSValue class]]) {
        //get type
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    //provide safe default implementation
    return (time < 0.5) ? fromValue : toValue;
}


//弹性球的缓冲函数，来源参考:http://www.robertpenner.com/easing
float bounceEaseOut(float t) {
    if (t < 4 / 11.0) {
        return (121 * t * t) / 16.0;
    } else if (t < 8 / 11.0) {
        return (363 / 40.0 * t * t) - (99 / 10.0 * t) + 17 / 5.0;
    } else if (t < 9 / 10.0) {
        return (4356 / 361.0 * t * t) - (35442 / 1805.0 * t) + 16061 / 1805.0;
    }
    return (54 / 5.0 * t * t) - (513 / 25.0 * t) + 268 / 25.0;
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
