//
//  PlayerLayerViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/13.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "PlayerLayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerLayerViewController ()
@property (nonatomic, strong) UIView *containerView;
@end

@implementation PlayerLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view. 
    self.view.backgroundColor = [UIColor lightGrayColor];
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 300, 240)];
    _containerView.backgroundColor = [UIColor darkGrayColor];
    _containerView.layer.cornerRadius = 20.0;
    _containerView.layer.borderWidth = 2.0;
    _containerView.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.view addSubview:_containerView];

    //用AVPlayerLayer播放视频
    //get video URL
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"MyShow" withExtension:@"mp4"];
    //create player and player layer
    AVPlayer *player = [AVPlayer playerWithURL:URL];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];

    //set player layer frame and attach it to our view
    playerLayer.frame = self.containerView.bounds;
    [self.containerView.layer addSublayer:playerLayer];

    //给视频增加3D变换，边框和圆角
    //transform layer
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 500.0;
    transform = CATransform3DRotate(transform, M_PI_4, 1, 1, 0);
    playerLayer.transform = transform;

    //add rounded corners and border
    playerLayer.masksToBounds = YES;
    playerLayer.cornerRadius = 20.0;
    playerLayer.borderColor = [UIColor redColor].CGColor;
    playerLayer.borderWidth = 5.0;

    //play the video
    [player play];
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
