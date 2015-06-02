//
//  ReplicatorLayerViewController.m
//  CoreAnimation-Demo
//
//  Created by luowei on 15/4/13.
//  Copyright (c) 2015年 luowei. All rights reserved.
//

#import "ReplicatorLayerViewController.h"
#import "ReflectionView.h"
#import "ScrollLayerView.h"

@interface ReplicatorLayerViewController ()

@end

@implementation ReplicatorLayerViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
////
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];


    //用CAReplicatorLayer绘制重复图层
    //create a replicator layer and add it to our view
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-108);
    [self.view.layer addSublayer:replicator];
    //configure the replicator
    replicator.instanceCount = 10;
    //apply a transform for each instance
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 10, 0, 0);
    transform = CATransform3DRotate(transform, M_PI / 5.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, -10, 0, 0);
    replicator.instanceTransform = transform;
    //apply a color shift for each instance
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceGreenOffset = -0.1;
    //create a sublayer and place it inside the replicator
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(160.0f, 200.0f, 50.0f, 50.0f);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicator addSublayer:layer];


    //添加一个反射视图，用CAReplicatorLayer自动绘制反射
    ReflectionView *reflectionView = [[ReflectionView alloc] initWithFrame:CGRectMake(20.0f, self.view.frame.origin.y+80, 50.0f, 50.0f)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mm.jpg"]];
    imageView.frame = reflectionView.bounds;
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [reflectionView addSubview:imageView];
//    reflectionView.layer.contents = (__bridge id)[UIImage imageNamed:@"mm.jpg"].CGImage;
    [self.view addSubview:reflectionView];


    //添加一个用CAScrollLayer实现滑动视图
    ScrollLayerView *scrollLayerView = [[ScrollLayerView alloc] initWithFrame:CGRectMake(150.0f, self.view.frame.origin.y+80, 150, 150)];
    scrollLayerView.layer.borderColor = [UIColor redColor].CGColor;
    scrollLayerView.layer.borderWidth = 1.0f;
    scrollLayerView.layer.cornerRadius = 10.0f;

    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mm.jpg"]];
    imageView2.frame = CGRectMake(0, 0, 300, 300);
    [scrollLayerView addSubview:imageView2];

    [self.view addSubview:scrollLayerView];
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
